// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2019 Intel Corporation

package common

// appConfig represents a struct of global configuration parameters.
type appConfig struct {
	Namespace        string
	ConsumerAppID    string
	ProducerAppID    string
	Notification     string
	VerNotif         string
	EdgeNodeEndpoint string
	ProducerEndpoint string
	EaaCommonName    string
	CertPath         string
	RootCAPath       string
	KeyPath          string
	ProducerTimeout  int
	ConsumerTimeout  int
}

// Cfg is a global congiguration used in edge apps.
var Cfg = appConfig{
	Namespace:        "ExampleNamespace",
	ConsumerAppID:    "ExampleConsumerAppID",
	ProducerAppID:    "ExampleProducerAppID",
	Notification:     "ExampleNotification",
	VerNotif:         "1.0.0",
	EdgeNodeEndpoint: "eaa.openness",
	ProducerEndpoint: "eaa.openness",
	EaaCommonName:    "eaa.openness",
	CertPath:         "./certs/cert.pem",
	RootCAPath:       "./certs/root.pem",
	KeyPath:          "./certs/key.pem",
	ProducerTimeout:  180, // in seconds
	ConsumerTimeout:  120} // in seconds
