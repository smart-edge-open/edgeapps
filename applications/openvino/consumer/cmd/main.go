// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2019-2020 Intel Corporation

package main

import (
	"bytes"
	"crypto/tls"
	"crypto/x509"
	"encoding/json"
	"github.com/gorilla/websocket"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"path/filepath"
)

// Connectivity constants
const (
	EAAServerName = "eaa.openness"
	EAAServerPort = "443"
	EAACommonName = "eaa.openness"
	CertPath      = "./certs/cert.pem"
	RootCAPath    = "./certs/root.pem"
	KeyPath       = "./certs/key.pem"
	megabyte      = 1024 * 1024
)

var myURN URN
var cpuSet string

// InferenceSettings is the notification structure of OpenVINO inference
// settings: model name & acceleration type
type InferenceSettings struct {
	Model       string `json:"model"`
	Accelerator string `json:"accelerator"`
}

//get file size
func getFileSize(path string) (int64, error) {
	fInfo, err := os.Stat(filepath.Clean(path))
	if err != nil {
		return 0, err
	}

	return fInfo.Size(), nil
}

// createEncryptedClient creates tls client with certs prorvided in
// CertPath, KeyPath
func createEncryptedClient() (*http.Client, *x509.CertPool, tls.Certificate, error) {

	log.Println("Loading certificate and key")
	cert, err := tls.LoadX509KeyPair(CertPath, KeyPath)
	if err != nil {
		log.Println("loadX509keyPair failed:", err)
	}

	certPool := x509.NewCertPool()
	sz, err := getFileSize(RootCAPath)
	if err != nil {
		log.Println("Get RootCA size failed:", err)
		return nil, certPool, cert, err
	}
	// Config file can't be larger than 1MB
	if sz > megabyte {
		log.Println("RootCA size too large failed")
		return nil, certPool, cert, err
	}
	caCert, err := ioutil.ReadFile(RootCAPath)
	if err != nil {
		log.Println("Read RootCA failed:", err)
		return nil, certPool, cert, err
	}
	ok := certPool.AppendCertsFromPEM(caCert)
	if !ok {
		log.Println("Append CACert failed")
		return nil, certPool, cert, err
	}

	// HTTPS client
	client := &http.Client{
		Transport: &http.Transport{
			TLSClientConfig: &tls.Config{
				RootCAs:      certPool,
				Certificates: []tls.Certificate{cert},
				ServerName:   EAACommonName,
				MinVersion:   tls.VersionTLS12,
			},
		},
		Timeout: 0,
	}
	log.Printf("%#v", client)

	return client, certPool, cert, nil
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
		log.Println("Establish websocket failed:", err)
		return nil, err
	}

	log.Println("WebSocket establishment successful")

	err = resp.Body.Close()
	if err != nil {
		log.Println("Resp websocket failed:", err)
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
	callOpenVINO(infSettings.Model, infSettings.Accelerator, cpuSet)
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
	if len(os.Args) < 2 {
		log.Fatal("Usage help: ./main <cpu_core>\nFor example: ./main 8")
	}
	log.Println("OpenVINO Consumer Started")
	cpuSet = os.Args[1]
	myURN = URN{
		ID:        "consumer",
		Namespace: "openvino",
	}

	// Authentication (CSR)
	log.Println("Create Encrypted client")
	client, certPool, cert, err := createEncryptedClient()
	if err != nil {
		log.Fatal(err)
		return
	}

	// Connection Establishment
	log.Println("Establish websocket Started")
	conn, err := establishWebsocket(certPool, cert)
	if err != nil {
		log.Fatal(err)
	}

	// Service Discovery
	log.Println("Service Discovery Started")
	servList, err := discoverServices(client)
	if err != nil {
		log.Fatal(err)
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
