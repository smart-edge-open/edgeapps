// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2019 Intel Corporation

package main

import (
	"bytes"
	"crypto/tls"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"time"

	"github.com/gorilla/websocket"
	"github.com/open-ness/edgeapps/applications/sample-app/common"
	"github.com/pkg/errors"
)

// subscribeConsumer sends a consumer subscription POST request to the appliance
// Subscribe to a set of notification types,
// optionally specifying the exact producer by URN.
func serviceSubscription(client *http.Client,
	notifs []common.NotificationDescriptor, path string) error {

	address := "https://" + common.Cfg.EdgeNodeEndpoint +
		"/subscriptions/" + path

	payload, err := json.Marshal(notifs)
	if err != nil {
		return errors.Wrap(err, "Couldn't marshal notifications")
	}

	req, err := http.NewRequest("POST", address, bytes.NewBuffer(payload))
	if err != nil {
		return errors.Wrap(err, "Couldn't create POST request for ")
	}

	respPost, err := client.Do(req)
	if err != nil {
		return errors.Wrap(err, "Couldn't send POST request to "+address)
	}
	defer func() {
		if err := respPost.Body.Close(); err != nil {
			log.Println("Failed to close response body")
		}
	}()
	return nil
}

// unsubscribeConsumer sends a consumer subscription POST request
// to the appliance
// Unsubscribe from a particular or entire namespace of producers.
func unsubscribeConsumer(c *http.Client, notifs []common.NotificationDescriptor,
	path string) error {

	address := "https://" + common.Cfg.EdgeNodeEndpoint +
		"/subscriptions/" + path

	payload, err := json.Marshal(notifs)
	if err != nil {
		return errors.Wrap(err, "Couldn't marshal notifications")
	}

	req, err := http.NewRequest("DELETE", address, bytes.NewBuffer(payload))
	if err != nil {
		return errors.Wrap(err,
			fmt.Sprintf("%s %s", "Couldn't create DELETE request for", address))
	}

	respPost, err := c.Do(req)
	if err != nil {
		return errors.Wrap(err, "Couldn't send POST request to "+address)
	}
	defer func() {
		if err := respPost.Body.Close(); err != nil {
			log.Println("Failed to close response body")
		}
	}()

	return nil
}

// connectConsumer sends a consumer notifications GET request to the appliance
// Connect to a secure WebSocket to receive streaming notifications
// (see reference for notification to consumer for schema of messages received
// on websocket).
func connectConsumer(client *http.Client) (*websocket.Conn, error) {

	transport, ok := client.Transport.(*http.Transport)
	if !ok {
		return nil, errors.New("HTTP client doens't have http.Transport")
	}

	socket := &websocket.Dialer{
		TLSClientConfig: &tls.Config{
			RootCAs: transport.TLSClientConfig.RootCAs,
			Certificates: []tls.Certificate{
				transport.TLSClientConfig.Certificates[0]},
			ServerName: common.Cfg.EaaCommonName,
			MinVersion: tls.VersionTLS12,
		},
	}

	hostHeader := http.Header{}
	hostHeader.Add("Host", common.Cfg.Namespace+":"+common.Cfg.ConsumerAppID)

	conn, resp, err := socket.Dial("wss://"+common.Cfg.EdgeNodeEndpoint+
		"/notifications", hostHeader)
	if err != nil {
		return nil, errors.Wrap(err, "Couldn't dial to wss")
	}
	defer func() {
		if err := resp.Body.Close(); err != nil {
			log.Println("Failed to close response body")
		}
	}()

	return conn, nil
}

// getMsgFromConn retrieves a message from a connection and parses
// it to a notification struct
func getMessages(conn *websocket.Conn) {

	err := conn.SetReadDeadline(time.Now().Add(time.Second *
		time.Duration(common.Cfg.ConsumerTimeout)))
	if err != nil {
		log.Println("Failed to set read dead line")
	}

	for {
		var resp common.NotificationToConsumer
		_, message, err := conn.ReadMessage()
		if err != nil {
			fmt.Println("Stopped reading messages")
			return
		}
		output := bytes.NewReader(message)
		err = json.NewDecoder(output).Decode(&resp)
		if err != nil {
			log.Println("Cannot decode a message")
		} else {
			fmt.Printf("Received notification:\n  Name: %v\n  Version: %v\n"+
				"  Payload: %v\n  URN: %v\n",
				resp.Name, resp.Version, string(resp.Payload), resp.URN)
		}
	}
}
