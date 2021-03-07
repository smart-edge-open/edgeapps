// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2019 Intel Corporation

package main

import (
	"bytes"
	"crypto/tls"
	"encoding/json"
	"log"
	"net/http"
	"reflect"
	"time"

	"github.com/gorilla/websocket"
	"github.com/open-ness/edgeapps/applications/sample-app/common"
	"github.com/pkg/errors"
)

const (
	maxWaitTime   = 3 * time.Second
	checkInterval = 500 * time.Millisecond
)

// payload struct contains data send in notification
type payload struct {
	Msg string `json:"msg"`
}

// registerProducer sends a registration POST request to the edgeNode
func registerProducer(cli *http.Client, producer common.Service) error {

	if cli == nil {
		return errors.New("Invalid http client")
	}

	var (
		err     error
		payload []byte
		req     *http.Request
		resp    *http.Response
	)

	if payload, err = json.Marshal(producer); err != nil {
		return errors.Wrap(err, "Failed to Marshal:")
	}

	if req, err = http.NewRequest("POST",
		"https://"+common.Cfg.EdgeNodeEndpoint+"/services",
		bytes.NewBuffer(payload)); err != nil {
		return errors.Wrap(err, "Failed to create new http request")
	}

	if resp, err = cli.Do(req); err != nil {
		return errors.Wrap(err, "Post response fail:")
	}

	defer func() {
		if err := resp.Body.Close(); err != nil {
			log.Println("Response body failed to close " + err.Error())
		}
	}()

	if resp.StatusCode != 200 {
		return errors.New("Response failed with status " + resp.Status)
	}

	return nil
}

// unregisterProducer sends a DELETE request to the edgeNode's EAA
func unregisterProducer(cli *http.Client) error {

	if cli == nil {
		return errors.New("Invalid http client")
	}

	var (
		err  error
		req  *http.Request
		resp *http.Response
	)

	if req, err = http.NewRequest("DELETE",
		"https://"+common.Cfg.EdgeNodeEndpoint+"/services", nil); err != nil {
		return errors.Wrap(err, "Failed to create new http request")
	}

	if resp, err = cli.Do(req); err != nil {
		return errors.Wrap(err, "Post response fail:")
	}

	defer func() {
		if err := resp.Body.Close(); err != nil {
			log.Println("Response body failed to close " + err.Error())
		}
	}()

	if resp.StatusCode != 204 {
		return errors.New("Response failed with status " + resp.Status)
	}

	return nil
}

// produceEvent sends a notification POST request to the edgeNode
func produceEvent(cli *http.Client,
	notif common.NotificationFromProducer) error {

	if cli == nil {
		return errors.New("Invalid http client")
	}

	var (
		err     error
		payload []byte
		req     *http.Request
		resp    *http.Response
	)

	if payload, err = json.Marshal(notif); err != nil {
		return errors.Wrap(err, "Failed to Marshal:")
	}

	if req, err = http.NewRequest("POST",
		"https://"+common.Cfg.EdgeNodeEndpoint+"/notifications",
		bytes.NewBuffer(payload)); err != nil {

		return errors.Wrap(err, "Failed to create new http request")
	}

	if resp, err = cli.Do(req); err != nil {
		return errors.Wrap(err, "Failed to send new http request")
	}

	defer func() {
		if err := resp.Body.Close(); err != nil {
			log.Println("Response body failed to close " + err.Error())
		}
	}()

	if resp.StatusCode != 202 {
		return errors.New("Response failed with status " + resp.Status)
	}

	return nil
}

// getServiceList sends a  GET request to the edgeNode
// and returns list of available services
func getServiceList(cli *http.Client) (common.ServiceList, error) {

	if cli == nil {
		return common.ServiceList{}, errors.New("Invalid http client")
	}

	respGet, _ := cli.Get("https://" +
		common.Cfg.EdgeNodeEndpoint + "/services")

	list := new(common.ServiceList)

	defer func() {
		if err := respGet.Body.Close(); err != nil {
			log.Println("Response body failed to close " + err.Error())
		}
	}()

	err := json.NewDecoder(respGet.Body).Decode(list)
	if err != nil {
		return common.ServiceList{}, errors.New("Invalid http client")
	}

	return *list, nil
}

func isServiceInList(service common.Service, list []common.Service) bool {
	for _, s := range list {
		if reflect.DeepEqual(service, s) {
			return true
		}
	}
	return false
}

// We can ask for list of available producer to be sure
// if we are indeed registered
func isProducerAvailable(cli *http.Client, producer common.Service) (bool, common.ServiceList) {
	allProducers := common.ServiceList{}
	var err error
	for start := time.Now(); time.Since(start) < maxWaitTime; {
		allProducers, err = getServiceList(cli)

		if err != nil {
			log.Panicln("Failed to get producers list " + err.Error())
		}

		if isServiceInList(producer, allProducers.Services) {
			return true, allProducers
		}
		time.Sleep(checkInterval)
	}
	return false, allProducers
}

// ConnectProducerWebsocket establishes a websocket connection for posting
// notifications to all subscribed consumers
func ConnectProducerWebsocket(client *http.Client) (*websocket.Conn, error) {
	// Get hold of the session handle
	transport, ok := client.Transport.(*http.Transport)
	if !ok {
		return nil, errors.New("HTTP client doens't have http.Transport")
	}

	// Construct websocket handle after populating it with the TLS configuration
	socket := &websocket.Dialer{
		TLSClientConfig: &tls.Config{
			RootCAs: transport.TLSClientConfig.RootCAs,
			Certificates: []tls.Certificate{
				transport.TLSClientConfig.Certificates[0]},
			ServerName: common.Cfg.EaaCommonName,
		},
	}

	// Set header for HTTP request to the websocket endpoint
	hostHeader := http.Header{}
	hostHeader.Add("Host", common.Cfg.Namespace+":"+common.Cfg.ProducerAppID)

	// Establish websocket connection by issuing a request to /notifications
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

	// Return websocket connection handle
	return conn, nil
}
