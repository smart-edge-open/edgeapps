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

package main

import (
	"encoding/json"
	"log"
	"time"

	"github.com/open-ness/edgeapps/sample-app/common"
	"github.com/pkg/errors"
)

// +---+                                           +--------+
// ¦App¦                                           ¦EdgeNode¦
// +---+                                           +--------+
//   ¦Register producer and declare notification       ¦
//   ¦------------------------------------------------>¦
//   ¦                                                 ¦
//   ¦ Response status - 200 OK                        ¦
//   ¦ [POST] /services
//   ¦<------------------------------------------------¦
//   ¦                                                 ¦
//   ¦ Produce event                                   ¦
//   ¦ [POST] /notifications
//   ¦------------------------------------------------>¦
//   ¦                                                 ¦
//   ¦ Response status - 202 Notification was received ¦
//   ¦  and will be forwarded                          ¦
//   ¦<------------------------------------------------¦
//   ¦                                                 ¦
//   ¦ Unregister Producer                             ¦
//   ¦ [DELETE] /services
//   ¦------------------------------------------------>¦
//   ¦                                                 ¦
//   ¦ Response status - 204  Service registration     ¦
//   ¦  removed                                        ¦
//   ¦<------------------------------------------------¦
// +---+                                           +--------+
// ¦App¦                                           ¦EdgeNode¦
// +---+                                           +--------+

func main() {

	// prepare producer structure
	producer := common.Service{
		URN: &common.URN{
			ID:        common.Cfg.ProducerAppID,
			Namespace: common.Cfg.Namespace,
		},
		Description: "The Example Producer",
		EndpointURI: common.Cfg.ProducerEndpoint,
		Notifications: []common.NotificationDescriptor{
			{
				Name:    common.Cfg.Notification,
				Version: common.Cfg.VerNotif,
				Description: "Description for Event #1 by " +
					"Example Producer",
			},
		},
	}

	// common name is namespace and producer id separated by semicolon
	commonName := common.Cfg.Namespace + ":" + common.Cfg.ProducerAppID

	// Create secure client
	// for more information go to /common/csr.go
	cli, err := common.CreateTLSClient(commonName)

	if err != nil {
		log.Fatal(err)
	}

	// send registration request to edgeNode
	if err = registerProducer(cli, producer); err != nil {
		log.Fatal(err)
	}

	// We can ask for list of available producer to be sure
	// if we are indeed registered
	allProducers, err := getServiceList(cli)

	if err != nil {
		log.Panicln("Failed to get producers list " + err.Error())
	}

	log.Println(allProducers)

	// after program finishes unregister producer
	defer func() {
		if err := unregisterProducer(cli); err != nil {
			log.Println(errors.Wrap(err, "Failed to unregister producer"))
		} else {
			log.Println("Producer unregistered gracefully")
		}

	}()

	// stop producer after set timeout
	done := time.After(time.Second * time.Duration(common.Cfg.ProducerTimeout))

workLoop:
	for {
		select {
		case <-done:
			// exit program
			break workLoop

		case <-time.Tick(time.Second * 3):
			log.Println("Sending notification")
			//prepare payload
			send, e := json.Marshal(payload{time.Now().Format(time.UnixDate)})

			if e != nil {
				log.Println("Failed to build json payload")
				break
			}

			// bild event
			newEvent := common.NotificationFromProducer{
				Name:    common.Cfg.Notification,
				Version: common.Cfg.VerNotif,
				Payload: send,
			}
			// send event to edgeNode
			if err := produceEvent(cli, newEvent); err != nil {
				log.Fatal(err)
			}
		}
	}

}
