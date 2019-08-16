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
	"bytes"
	"encoding/json"
	"log"
	"net/http"

	"github.com/open-ness/edgeapps/sample-app/common"
	"github.com/pkg/errors"
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
