// Copyright 2019 Intel Corporation. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package main

import (
	"bytes"
	"crypto/ecdsa"
	"crypto/elliptic"
	"crypto/rand"
	"crypto/tls"
	"crypto/x509"
	"crypto/x509/pkix"
	"encoding/json"
	"encoding/pem"
	"log"
	"net/http"

	"github.com/gorilla/websocket"
)

// Connectivity constants
const (
	EAAServerName = "eaa.openness"
	EAAServerPort = "443"
	EAAServPort   = "80"
	EAACommonName = "eaa.openness"
)

var myURN URN

// InferenceSettings is the notification structure of OpenVINO inference
// settings: model name & acceleration type
type InferenceSettings struct {
	Model       string `json:"model"`
	Accelerator string `json:"accelerator"`
}

func authenticate(prvKey *ecdsa.PrivateKey) (*x509.CertPool, tls.Certificate) {
	certTemplate := x509.CertificateRequest{
		Subject: pkix.Name{
			CommonName:   "openvino:consumer",
			Organization: []string{"Intel Corporation"},
		},
		SignatureAlgorithm: x509.ECDSAWithSHA256,
		EmailAddresses:     []string{"hello@openness.org"},
	}

	conCsrBytes, err := x509.CreateCertificateRequest(rand.Reader,
		&certTemplate, prvKey)
	if err != nil {
		log.Fatal(err)
	}

	csrMem := pem.EncodeToMemory(&pem.Block{Type: "CERTIFICATE REQUEST",
		Bytes: conCsrBytes})

	conID := AuthIdentity{
		Csr: string(csrMem),
	}

	reqBody, err := json.Marshal(conID)
	if err != nil {
		log.Fatal(err)
	}
	resp, err := http.Post("http://"+EAAServerName+":"+EAAServPort+"/auth",
		"", bytes.NewBuffer(reqBody))
	if err != nil {
		log.Fatal(err)
	}

	var conCreds AuthCredentials
	err = json.NewDecoder(resp.Body).Decode(&conCreds)
	if err != nil {
		log.Fatal(err)
	}

	x509Encoded, err := x509.MarshalECPrivateKey(prvKey)
	if err != nil {
		log.Fatal(err)
	}

	pemEncoded := pem.EncodeToMemory(&pem.Block{Type: "PRIVATE KEY",
		Bytes: x509Encoded})
	conCert, err := tls.X509KeyPair([]byte(conCreds.Certificate),
		pemEncoded)
	if err != nil {
		log.Fatal(err)
	}

	conCertPool := x509.NewCertPool()
	for _, cert := range conCreds.CaPool {
		ok := conCertPool.AppendCertsFromPEM([]byte(cert))
		if !ok {
			log.Fatal("Error: failed to append cert")
		}
	}

	return conCertPool, conCert
}

func establishWebsocket(certPool *x509.CertPool,
	cert tls.Certificate) (*websocket.Conn, error) {

	var socket = websocket.Dialer{
		ReadBufferSize:  512,
		WriteBufferSize: 512,
		TLSClientConfig: &tls.Config{
			RootCAs:      certPool,
			Certificates: []tls.Certificate{cert},
			ServerName:   EAACommonName,
		},
	}

	var header = http.Header{}
	header["Host"] = []string{myURN.Namespace + ":" + myURN.ID}

	// Consumer establishes websocket with EAA
	conn, resp, err := socket.Dial("wss://"+EAAServerName+":"+EAAServerPort+
		"/notifications", header)
	if err != nil {
		return nil, err
	}

	log.Println("WebSocket establishment successful")

	err = resp.Body.Close()
	if err != nil {
		return nil, err
	}

	return conn, nil
}

func discoverServices(client *http.Client) (ServiceList, error) {
	var servList = ServiceList{}

	// Consumer discover services
	req, err := http.NewRequest("GET",
		"https://"+EAAServerName+":"+EAAServerPort+"/services", nil)
	if err != nil {
		log.Println("Service-discovery request creation failed:", err)
		return servList, err
	}

	resp, err := client.Do(req)
	if err != nil {
		log.Println("Service-discovery request failed:", err)
		return servList, err
	}

	// TODO check if service list is empty -> handle & exit program

	err = json.NewDecoder(resp.Body).Decode(&servList)
	if err != nil {
		log.Println("Service-list decode failed:", err)
		return servList, err
	}

	err = resp.Body.Close()
	if err != nil {
		return servList, err
	}

	return servList, nil
}

func subscribeService(client *http.Client, service Service) error {

	notifBytes, _ := json.Marshal(service.Notifications)

	// Consumer unsubscribes from EAA for preparation to close connection
	req, err := http.NewRequest("POST",
		"https://"+EAAServerName+":"+EAAServerPort+"/subscriptions/"+
			service.URN.Namespace, bytes.NewReader(notifBytes))
	if err != nil {
		log.Println("Unsubscription request creation failed:", err)
		return err
	}

	resp, err := client.Do(req)
	if err != nil {
		log.Println("Unsubscription request failed:", err)
		return err
	}

	err = resp.Body.Close()
	if err != nil {
		return err
	}

	return nil
}

func getSubscriptions(client *http.Client) (SubscriptionList, error) {
	var subscrList = SubscriptionList{}

	// Consumer lists its subscriptions
	req, err := http.NewRequest("GET",
		"https://"+EAAServerName+":"+EAAServerPort+"/subscriptions", nil)
	if err != nil {
		log.Println("List-subscriptions request creation failed:", err)
		return subscrList, err
	}

	resp, err := client.Do(req)
	if err != nil {
		log.Println("List-subscriptions request failed:", err)
		return subscrList, err
	}

	err = json.NewDecoder(resp.Body).Decode(&subscrList)
	if err != nil {
		log.Println("List-subscriptions decode failed:", err)
		return subscrList, err
	}

	err = resp.Body.Close()
	if err != nil {
		return subscrList, err
	}

	return subscrList, nil
}

func unsubscribeAll(client *http.Client) error {
	// Consumer unsubscribes from EAA for preparation to close connection
	req, err := http.NewRequest("DELETE",
		"https://"+EAAServerName+":"+EAAServerPort+"/subscriptions", nil)
	if err != nil {
		log.Println("Unsubscription request creation failed:", err)
		return err
	}

	resp, err := client.Do(req)
	if err != nil {
		log.Println("Unsubscription request failed:", err)
		return err
	}

	err = resp.Body.Close()
	if err != nil {
		return err
	}

	return nil
}

func switchModel(payload []byte) {

	var infSettings = InferenceSettings{}
	err := json.Unmarshal(payload, &infSettings)
	if err != nil {
		log.Println("Failed to unmarshal notification payload:", err)
		return
	}

	log.Println("Rx notification -- " + infSettings.Model + " | " +
		infSettings.Accelerator)

	// Call OpenVINO C++ App with the model name & acceleration type
	callOpenVINO(infSettings.Model, infSettings.Accelerator)
}

func notifListener(conn *websocket.Conn, client *http.Client) {

	// Set to true if more processing expected, will be
	// updated when Producer sends terminate message
	keepListen := true

	for keepListen {
		_, message, err := conn.ReadMessage()
		if err != nil {
			log.Println("Failed to read message from WebSocket:", err)
			return
		}

		var notif = NotificationToConsumer{}
		err = json.Unmarshal(message, &notif)
		if err != nil {
			log.Println("Failed to unmarshal notification msg:", err)
			return
		}

		switch notif.Name {
		case "openvino-inference":
			switchModel(notif.Payload)

		// Unsubscribe from services, remove WebSocket
		// then break out of loop to exit routine
		case "terminate":
			keepListen = false
		}
	}

	// Service Unsubscription
	err := unsubscribeAll(client)
	if err != nil {
		log.Println("Service Unsubscription failed:", err)
	}
	// WebSocket Termination
	err = conn.Close()
	if err != nil {
		log.Println("Failed to close the WebSocket connection:", err)
	}
}

func main() {
	log.Println("OpenVINO Consumer Started")

	myURN = URN{
		ID:        "consumer",
		Namespace: "openvino",
	}

	// Authentication (CSR)
	conPriv, err := ecdsa.GenerateKey(elliptic.P256(), rand.Reader)
	if err != nil {
		log.Fatal(err)
	}
	certPool, cert := authenticate(conPriv)

	// HTTPS client
	client := &http.Client{
		Transport: &http.Transport{
			TLSClientConfig: &tls.Config{
				RootCAs:      certPool,
				Certificates: []tls.Certificate{cert},
				ServerName:   EAACommonName,
			},
		},
		Timeout: 0,
	}

	// Connection Establishment
	conn, err := establishWebsocket(certPool, cert)
	if err != nil {
		log.Fatal(err)
	}

	// Service Discovery
	servList, err := discoverServices(client)
	if err != nil {
		return
	}

	for _, s := range servList.Services {
		// Subscribe to all services related to my Namespace
		if myURN.Namespace == s.URN.Namespace {
			// Service Subscription
			err = subscribeService(client, servList.Services[0])
			if err != nil {
				return
			}
		}
	}

	// List Subscription
	SubList, err := getSubscriptions(client)
	if err != nil {
		return
	}

	for _, s := range SubList.Subscriptions {
		for _, n := range s.Notifications {
			log.Println("Subscribed to notification:", n.Name, n.Version)
		}
	}

	// Inititate notification events listener
	notifListener(conn, client)
}
