// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2019 Intel Corporation

package main

import (
	"encoding/json"
	"log"
	"time"

	"github.com/smart-edge-open/edgeapps/applications/sample-app/common"
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

	// Create secure client
	// for more information go to /common/csr.go
	cli, err := common.CreateEncryptedClient()

	if err != nil {
		log.Fatal(err)
	}

	// send registration request to edgeNode
	if err = registerProducer(cli, producer); err != nil {
		log.Fatal(err)
	}

	// check if we have a producer available
	isAvailable, allProducers := isProducerAvailable(cli, producer)

	if !isAvailable {
		log.Panicln("No producers available")
	}

	log.Println("\nCurrent producers: ")
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
