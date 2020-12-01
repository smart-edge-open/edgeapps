// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2019 Intel Corporation

package main

import (
	"log"

	"github.com/otcshare/edgeapps/applications/sample-app/common"
)

// The Consumer creates a Web Socket connection to edge node. After that
// it subscribes for a notification from a producer. The customer is ready to
// handle notificatios at this point. At the end the custome unsubscribe from
// the notification.
// +--------+                      +---------+
// ¦Consumer¦                      ¦Edge Node¦
// +--------+                      +---------+
// 	¦                                ¦
// 	¦                   +-------------------+
// ---------------------¦ secure connection ¦----------------------------------
// 	¦                   +-------------------+
// 	¦                                ¦
// 	¦       connect a consumer       ¦
// 	¦ <------------------------------>
// 	¦                                ¦
// 	¦  +--------------------------------+
// 	¦  ¦create a web socket connection ¦¦
// 	¦  +--------------------------------+
// 	¦                                ¦
// 	¦                                ¦
// 	¦                                ¦
// 	¦                                ¦
// 	¦                                ¦
// 	¦  subscribe for a notification  ¦
// 	¦ ------------------------------->
// 	¦                                ¦
// 	¦                                ¦  +--------------------------+
// 	¦                                ¦  ¦edge node sends all      ¦¦
// 	¦                                ¦  ¦producer-created-events  ¦¦
// 	¦                                ¦  ¦for the consumer         ¦¦
// 	¦                                ¦  +--------------------------+
// 	¦                                ¦
// 	¦                                ¦
// 	¦ unsubscribe from a notification¦
// 	¦ ------------------------------->
// 	¦                                ¦
// +--------+                      +---------+
// ¦Consumer¦                      ¦Edge Node¦
// +--------+                      +---------+

func main() {

	client, err := common.CreateEncryptedClient()

	if err != nil {
		panic("Couldn't create TLS connection to edge node: " + err.Error())
	}

	webSocketConnection, err := connectConsumer(client)
	if err != nil {
		panic("Cannot open a web socket: " + err.Error())
	}
	defer func() {
		if conErr := webSocketConnection.Close(); conErr != nil {
			log.Println("Failed to close socket")
		}
	}()
	if err = serviceSubscription(client, common.SampleNotification,
		common.Cfg.Namespace); err != nil {
		panic("Cannot subscribe for notification: " + err.Error())
	}

	getMessages(webSocketConnection)

	err = unsubscribeConsumer(client, common.SampleNotification,
		common.Cfg.Namespace)
	if err != nil {
		panic("Cannot unsubscribe: " + err.Error())
	}

}
