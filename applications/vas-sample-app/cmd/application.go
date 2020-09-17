// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2020 Intel Corporation

package main

import (
	"bytes"
	"encoding/json"
	"log"
	"net/http"
	"time"
)

type VASPostSource struct {
	URI  string `json:"uri"`
	Type string `json:"type"`
}

type VASPostDestination struct {
	Path   string `json:"path"`
	Type   string `json:"type"`
	Format string `json:"format"`
}

type VASPostRequest struct {
	Source      *VASPostSource      `json:"source"`
	Destination *VASPostDestination `json:"destination"`
}

type VASInstanceStatus struct {
	StartTime   float64 `json:"start_time"`
	ElapsedTime float64 `json:"elapsed_time"`
	ID          int     `json:"id"`
	State       string  `json:"state"`
	AvgFPS      float64 `json:"avg_fps"`
}

func postVAServingRequest(vaEndPoint string, vaPipeline string) error {

	// Interface: POST /pipelines/{name}/{version} for Start new pipeline instance
	VASRequest := VASPostRequest{
		Source: &VASPostSource{
			URI:  "https://github.com/intel-iot-devkit/sample-videos/blob/master/bottle-detection.mp4?raw=true",
			Type: "uri",
		},
		Destination: &VASPostDestination{
			Path:   "/tmp/results.txt",
			Type:   "file",
			Format: "json-lines",
		},
	}

	endPointStr := vaEndPoint + "/pipelines/" + vaPipeline
	log.Println("Starting POST Request: ", endPointStr)

	VASReqPayload, err := json.Marshal(VASRequest)
	if err != nil {
		log.Fatal(err)
	}

	VASPostResp, err := http.Post(endPointStr, "application/json; charset=UTF-8", bytes.NewBuffer(VASReqPayload))
	for VASPostResp.StatusCode == http.StatusServiceUnavailable {
		log.Println("Pipeline service is not currently available, trying again")
		time.Sleep(time.Duration(5) * time.Second)
		VASPostResp, err = http.Post(endPointStr, "", bytes.NewBuffer(VASReqPayload))
	}
	if err != nil {
		log.Fatal(err)
	}

	var VASRespBody interface{}
	err = json.NewDecoder(VASPostResp.Body).Decode(&VASRespBody)
	if err != nil {
		log.Fatal(err)
	}
	parsedRespBody, err := json.MarshalIndent(VASRespBody, "<prefix>", "<indent>")
	if err != nil {
		log.Fatal(err)
	}
	instanceID := string(parsedRespBody)

	err = VASPostResp.Body.Close()
	if err != nil {
		log.Fatal(err)
	}

	// Interface: GET /pipelines/{name}/{version}/{instance_id}/status for Return pipeline instance status.
	for {
		getEndPointStr := endPointStr + "/" + instanceID + "/status"
		log.Println("Starting status check: ", getEndPointStr)
		VASGetResp, err := http.Get(getEndPointStr)
		for VASGetResp.StatusCode == http.StatusServiceUnavailable {
			log.Println("Pipeline status service is not currently available, trying again")
			time.Sleep(time.Duration(5) * time.Second)
			VASGetResp, err = http.Get(getEndPointStr)
		}
		if err != nil {
			log.Fatal(err)
		}

		var statusResp VASInstanceStatus
		err = json.NewDecoder(VASGetResp.Body).Decode(&statusResp)
		if err != nil {
			log.Fatal(err)
		}

		log.Printf("{\n avg_fps: %f,\n elapsed_time: %f\n id: %d\n start_time: %f\n state: %s\n}\n",
			statusResp.AvgFPS, statusResp.ElapsedTime, statusResp.ID, statusResp.StartTime, statusResp.State)

		if statusResp.State == "COMPLETED" {
			break
		} else if statusResp.State == "ERROR" {
			log.Fatal("Error with VAS pipeline instance")
		}

		err = VASGetResp.Body.Close()
		if err != nil {
			log.Fatal(err)
		}
		time.Sleep(time.Duration(10) * time.Second)
	}

	return nil
}
