// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2019-2020 Intel Corporation

package main

import (
	"bytes"
	"crypto/tls"
	"crypto/x509"
	"encoding/json"
	"github.com/pkg/errors"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"time"
)

// Connectivity constants
const (
	EAAServerName = "eaa.openness"
	EAAServerPort = "443"
	EAACommonName = "eaa.openness"
	CertPath      = "./certs/cert.pem"
	RootCAPath    = "./certs/root.pem"
	KeyPath       = "./certs/key.pem"
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

// createEncryptedClient creates tls client with certs prorvided in
// CertPath, KeyPath
func createEncryptedClient() (*http.Client, error) {

	log.Println("Loading certificate and key")
	cert, err := tls.LoadX509KeyPair(CertPath, KeyPath)
	if err != nil {
		return nil, errors.Wrap(err, "Failed to load client certificate")
	}

	certPool := x509.NewCertPool()
	caCert, err := ioutil.ReadFile(RootCAPath)
	if err != nil {
		return nil, errors.Wrap(err, "Failed to load CA Cert")
	}
	ok := certPool.AppendCertsFromPEM(caCert)
	if !ok {
		return nil, errors.New("Failed to append cert")
	}

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
	log.Printf("%#v", client)

	return client, nil
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

	// Authentication
	log.Println("Create Encrypted client")
	client, err := createEncryptedClient()
	if err != nil {
		log.Fatal(err)
		return
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
