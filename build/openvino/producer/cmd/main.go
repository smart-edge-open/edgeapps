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
	"errors"
	"log"
	"net/http"
	"os"
	"time"
)

// Connectivity constants
const (
	EAAServerName = "eaa.community.appliance.mec"
	EAAServerPort = "443"
	EAAServPort   = "80"
	EAACommonName = "eaa.community.appliance.mec"
)

// OpenVINO acceleration types
const (
	CPU    = "CPU"
	MYRIAD = "MYRIAD"
	HDDL   = "HDDL"
)

// InferenceSettings is the notification structure of OpenVINO inference
// settings: model name & acceleration type
type InferenceSettings struct {
	Model       string `json:"model"`
	Accelerator string `json:"accelerator"`
}

func getCredentials(prvKey *ecdsa.PrivateKey) AuthCredentials {
	certTemplate := x509.CertificateRequest{
		Subject: pkix.Name{
			CommonName:   "openvino:producer",
			Organization: []string{"Intel Corporation"},
		},
		SignatureAlgorithm: x509.ECDSAWithSHA256,
		EmailAddresses:     []string{"hello@openness.org"},
	}

	prodCsrBytes, err := x509.CreateCertificateRequest(rand.Reader,
		&certTemplate, prvKey)
	if err != nil {
		log.Fatal(err)
	}
	csrMem := pem.EncodeToMemory(&pem.Block{Type: "CERTIFICATE REQUEST",
		Bytes: prodCsrBytes})

	prodID := AuthIdentity{
		Csr: string(csrMem),
	}

	reqBody, err := json.Marshal(prodID)
	if err != nil {
		log.Fatal(err)
	}
	resp, err := http.Post("http://"+EAAServerName+":"+EAAServPort+"/auth",
		"", bytes.NewBuffer(reqBody))
	if err != nil {
		log.Fatal(err)
	}

	var prodCreds AuthCredentials
	err = json.NewDecoder(resp.Body).Decode(&prodCreds)
	if err != nil {
		log.Fatal(err)
	}

	return prodCreds
}

func authenticate(prvKey *ecdsa.PrivateKey) (*http.Client, error) {
	prodCreds := getCredentials(prvKey)

	x509Encoded, err := x509.MarshalECPrivateKey(prvKey)
	if err != nil {
		return nil, err
	}

	pemEncoded := pem.EncodeToMemory(&pem.Block{Type: "PRIVATE KEY",
		Bytes: x509Encoded})
	prodCert, err := tls.X509KeyPair([]byte(prodCreds.Certificate),
		pemEncoded)
	if err != nil {
		return nil, err
	}

	prodCertPool := x509.NewCertPool()
	for _, cert := range prodCreds.CaPool {
		ok := prodCertPool.AppendCertsFromPEM([]byte(cert))
		if !ok {
			return nil, errors.New("Error: failed to append cert")
		}
	}

	// HTTPS client
	prodClient := &http.Client{
		Transport: &http.Transport{
			TLSClientConfig: &tls.Config{
				RootCAs:      prodCertPool,
				Certificates: []tls.Certificate{prodCert},
				ServerName:   EAACommonName,
			},
		},
		Timeout: 0,
	}

	return prodClient, nil
}

func activateService(client *http.Client, payload []byte) {

	req, err := http.NewRequest("POST",
		"https://"+EAAServerName+":"+EAAServerPort+"/services",
		bytes.NewReader(payload))
	if err != nil {
		log.Println("Service-activation request creation failed:", err)
		return
	}

	resp, err := client.Do(req)
	if err != nil {
		log.Println("Service-activation request failed:", err)
		return
	}
	log.Println("Service-activation request sent to the server")

	err = resp.Body.Close()
	if err != nil {
		return
	}
}

func postNotif(client *http.Client, payload []byte) {

	req, err := http.NewRequest("POST",
		"https://"+EAAServerName+":"+EAAServerPort+"/notifications",
		bytes.NewReader(payload))
	if err != nil {
		log.Println("Service-activation request creation failed:", err)
		return
	}

	resp, err := client.Do(req)
	if err != nil {
		log.Println("Service-activation request failed:", err)
		return
	}

	err = resp.Body.Close()
	if err != nil {
		return
	}
}

func deactivateService(client *http.Client) {

	req, err := http.NewRequest("DELETE",
		"https://"+EAAServerName+":"+EAAServerPort+"/services", nil)
	if err != nil {
		log.Println("Unsubscription request creation failed:", err)
		return
	}

	resp, err := client.Do(req)
	if err != nil {
		log.Println("Unsubscription request failed:", err)
		return
	}

	err = resp.Body.Close()
	if err != nil {
		return
	}
}

func main() {
	log.Println("OpenVINO Producer Application Started")

	prodURN := URN{
		ID:        "producer",
		Namespace: "openvino",
	}

	notifOpenVINO := NotificationDescriptor{
		Name:        "openvino-inference",
		Version:     "1.0.0",
		Description: "Settings to use for OpenVINO inference",
	}

	notifTerm := NotificationDescriptor{
		Name:        "terminate",
		Version:     "1.0.0",
		Description: "End of transmission signal",
	}

	serv := Service{
		URN:         &prodURN,
		Description: "Notification for OpenVINO inference settings",
		EndpointURI: "openvino/producer",
	}

	// perform CSR to authenticate and retrieve certificate
	prodPriv, err := ecdsa.GenerateKey(elliptic.P256(), rand.Reader)
	if err != nil {
		log.Fatal(err)
	}

	client, err := authenticate(prodPriv)
	if err != nil {
		log.Fatal(err)
	}

	// get acceleration type from env variables
	openvinoAccl := os.Getenv("OPENVINO_ACCL")

	var accl [2]string
	switch openvinoAccl {
	case "CPU":
		accl[0] = CPU
		accl[1] = CPU
	case "MYRIAD":
		accl[0] = MYRIAD
		accl[1] = MYRIAD
	case "HDDL":
		accl[0] = HDDL
		accl[1] = HDDL
	case "CPU_HDDL":
		accl[0] = CPU
		accl[1] = HDDL
	case "CPU_MYRIAD":
		accl[0] = CPU
		accl[1] = MYRIAD
	}

	var infSettings [4]InferenceSettings
	infSettings[0] = InferenceSettings{
		"pedestrian-detection-adas-0002", accl[0]}
	infSettings[1] = InferenceSettings{
		"vehicle-detection-adas-0002", accl[0]}
	infSettings[2] = InferenceSettings{
		"pedestrian-detection-adas-0002", accl[1]}
	infSettings[3] = InferenceSettings{
		"vehicle-detection-adas-0002", accl[1]}

	serv.Notifications = make([]NotificationDescriptor, 1)
	serv.Notifications = make([]NotificationDescriptor, 2)
	serv.Notifications[0] = notifOpenVINO
	serv.Notifications[1] = notifTerm

	requestByte, _ := json.Marshal(serv)

	// Producer activates new service
	activateService(client, requestByte)

	// instantiate a notification instance
	notif := NotificationFromProducer{}
	notif.Name = notifOpenVINO.Name
	notif.Version = notifOpenVINO.Version

	// TODO: introduce a better mechanism for alternating models
	// other than a limited for-loop
	for i := 0; i < 1000; i++ {
		jIS, _ := json.Marshal(infSettings[i%4])
		notif.Payload = jIS
		requestByte, _ = json.Marshal(notif)
		// Producer posts notification
		postNotif(client, requestByte)
		log.Println("Inference settings:", infSettings[i%4])
		// wait
		time.Sleep(60 * time.Second)
	}

	// Producer send terminate signal
	notif.Name = notifTerm.Name
	notif.Version = notifTerm.Version
	p, _ := json.Marshal("")
	notif.Payload = p
	requestByte, _ = json.Marshal(notif)

	req, err := http.NewRequest("POST",
		"https://"+EAAServerName+":"+EAAServerPort+"/notifications",
		bytes.NewReader(requestByte))
	if err != nil {
		log.Println("Failed to create terminate signal request:", err)
		return
	}

	resp, err := client.Do(req)
	if err != nil {
		log.Println("Service-termination message request failed:", err)
		return
	}

	err = resp.Body.Close()
	if err != nil {
		return
	}

	// Producer deactivates service
	deactivateService(client)
}
