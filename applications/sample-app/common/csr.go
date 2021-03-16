// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2019 Intel Corporation

package common

import (
	"crypto/tls"
	"crypto/x509"
	"io/ioutil"
	"log"
	"net/http"

	"github.com/pkg/errors"
)

// CreateEncryptedClient creates tls client with certs prorvided in
// Cfg struct (sample-app/common/conf.go)
func CreateEncryptedClient() (*http.Client, error) {
	log.Println("new log")

	cert, err := tls.LoadX509KeyPair(Cfg.CertPath, Cfg.KeyPath)
	if err != nil {
		return nil, errors.Wrap(err, "Failed to load client certificate")
	}

	certPool := x509.NewCertPool()
	caCert, err := ioutil.ReadFile(Cfg.RootCAPath)
	if err != nil {
		return nil, errors.Wrap(err, "Failed to load CA Cert")
	}
	certPool.AppendCertsFromPEM(caCert)

	client := &http.Client{
		Transport: &http.Transport{
			TLSClientConfig: &tls.Config{RootCAs: certPool,
				Certificates: []tls.Certificate{cert},
				ServerName:   Cfg.EaaCommonName,
				MinVersion:   tls.VersionTLS12,
			},
		}}

	log.Printf("%#v", client)

	tlsResp, err := client.Get("https://" + Cfg.EdgeNodeEndpoint)
	if err != nil {
		return nil, errors.Wrap(err, "Encrypted connection failure")
	}
	defer func() {
		if e := tlsResp.Body.Close(); e != nil {
			log.Println("Failed to close response body " + e.Error())
		}
	}()
	return client, nil
}
