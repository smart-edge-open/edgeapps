// Copyright 2019 Intel Corporation and Smart-Edge.com, Inc. All rights reserved
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
	EdgeNodeEndpoint: "localhost",
	ProducerEndpoint: "localhost",
	EaaCommonName:    "eaa.openness",
	ProducerTimeout:  180, // in seconds
	ConsumerTimeout:  120} // in seconds
