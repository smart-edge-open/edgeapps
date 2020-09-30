// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2020 Intel Corporation

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
	"time"
)

// Connectivity constants
const (
	EAAServerName = "eaa.openness"
	EAAServerPort = "443"
	EAAServPort   = "80"
	EAACommonName = "eaa.openness"
)

var myURN URN

// VasConfig describes VAS JSON config file
type VasConfig struct {
	Acceleration string   `json:"Acceleration"`
	Framework    string   `json:"Framework"`
	Pipelines    []string `json:"Pipelines"`
}

func authenticate(prvKey *ecdsa.PrivateKey) (*x509.CertPool, tls.Certificate) {
	certTemplate := x509.CertificateRequest{
		Subject: pkix.Name{
			CommonName:   "media:consumer",
			Organization: []string{"Intel Corporation"},
		},
		SignatureAlgorithm: x509.ECDSAWithSHA256,
		EmailAddresses:     []string{"hello@openness.org"},
	}

	log.Println("CSR creating certificate")
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
	log.Println("CSR POST /auth")
	resp, err := http.Post("http://"+EAAServerName+":"+EAAServPort+"/auth",
		"", bytes.NewBuffer(reqBody))
	if err != nil {
		log.Fatal(err)
	}
	reconnectTries := 0
	for resp.StatusCode == http.StatusServiceUnavailable && reconnectTries < 10 {
		reconnectTries++
		log.Println("EAA service is not currently available, trying again")
		time.Sleep(time.Duration(5) * time.Second)
		resp, err = http.Post("http://"+EAAServerName+":"+EAAServPort+"/auth",
			"", bytes.NewBuffer(reqBody))
		if err != nil {
			log.Fatal(err)
		}
	}
	if reconnectTries == 10 {
		log.Fatal("Number of connection retries to EAA Auth exceeded, exiting")
	}

	var conCreds AuthCredentials
	err = json.NewDecoder(resp.Body).Decode(&conCreds)
	if err != nil {
		log.Fatal(err)
	}

	err = resp.Body.Close()
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
	reconnectTries := 0
	for resp.StatusCode == http.StatusServiceUnavailable && reconnectTries < 10 {
		reconnectTries++
		log.Println("EAA service is not currently available, trying again")
		time.Sleep(time.Duration(5) * time.Second)
		resp, err = client.Do(req)
		if err != nil {
			log.Println("Service-discovery request failed:", err)
			return servList, err
		}
	}
	if reconnectTries == 10 {
		log.Fatal("Number of connection retries to EAA Service Discovery exceeded, exiting")
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

func main() {
	log.Println("Video-analytics-service Consumer Started")

	myURN = URN{
		ID:        "consumer",
		Namespace: "default",
	}

	// Authentication (CSR)
	log.Println("CSR Started")
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

	// Service Discovery
	log.Println("Service Discovery Started")
	servList, err := discoverServices(client)
	if err != nil {
		log.Fatal(err)
		return
	}

	sum := 0
	var vasInfo VasConfig
	for _, s := range servList.Services {
		sum++
		if sum > 100 {
			log.Fatal("abnormal services num")
			return
		}
		log.Println("Discovered service:")
		log.Println("    URN.ID:       ", s.URN.ID)
		log.Println("    URN.Namespace:", s.URN.Namespace)
		log.Println("    Description:  ", s.Description)
		log.Println("    EndpointURI:  ", s.EndpointURI)
		// Subscribe to all services related to my Namespace
		if myURN.Namespace == s.URN.Namespace {
			// Service Request to VA-Serving
			err := json.Unmarshal(s.Info, &vasInfo)
			if err != nil {
				log.Println(err)
			}
			postVAServingRequest(s.EndpointURI, vasInfo.Pipelines[0])
		} else {
			log.Println("Namespace mismatch, myURN namespace:", myURN.Namespace)
		}
	}
}
