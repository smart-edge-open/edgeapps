// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2019 Intel Corporation

package main

import (
	"io"
	"log"
	"os"
	"os/exec"
	"strings"
)

// OpenVINO acceleration types
const (
	CPU    = "CPU"
	MYRIAD = "MYRIAD"
	HDDL   = "HDDL"
)

var cmd *exec.Cmd

func callOpenVINO(model string, accl string) {

	// validate accelerator type
	switch accl {
	case CPU:
	case MYRIAD:
	case HDDL:
	default:
		log.Println("ERROR: uknown acceleration type (" + accl + ")")
		return
	}

	// kill already running process if not the first time
	if cmd != nil && cmd.Process != nil {
		err := cmd.Process.Kill()
		if err != nil {
			log.Fatal("Failed to kill OpenVINO process:", err)
		}
		_ = cmd.Wait()
	}

	var openvinoPath = "/opt/intel/openvino_2021/deployment_tools/inference_engine/demos/python_demos/object_detection_demo_ssd_async/"
	var openvinoCmd = "object_detection_demo_ssd_async.py"

	var modelXML string
	if accl == CPU {
		modelXML = model + "/FP32/" + model + ".xml"
	} else {
		modelXML = model + "/FP16/" + model + ".xml"
	}

	// get taskset cpu from env
	openvinoTasksetCPU := os.Getenv("OPENVINO_TASKSET_CPU")

	// #nosec
	err := os.Chdir(openvinoPath)
	if err != nil {
		log.Fatal("Failed to change directory:", err)
	}
	cmd = exec.Command("taskset", "-c", openvinoTasksetCPU,
		"python3", openvinoCmd, "-d", accl,
		"-i", "rtmp://127.0.0.1:5000/live/test.flv",
		"-m", modelXML)

	stderr, _ := cmd.StderrPipe()
	go func(reader io.ReadCloser) {
		bucket := make([]byte, 1024)
		buffer := make([]byte, 100)
		for {
			num, err := reader.Read(buffer)
			if err != nil {
				if err == io.EOF || strings.Contains(err.Error(), "closed") {
					err = nil
				}
				return
			}
			if num > 0 {
				line := ""
				bucket = append(bucket, buffer[:num]...)
				tmp := string(bucket)
				if strings.Contains(tmp, "\n") {
					ts := strings.Split(tmp, "\n")
					if len(ts) > 1 {
						line = strings.Join(ts[:len(ts)-1], "\n")
						bucket = []byte(ts[len(ts)-1])
					} else {
						line = ts[0]
						bucket = bucket[:0]
					}
					log.Printf("%s\n", line)
				}
			}
		}
	}(stderr)

	err = cmd.Start()
	if err != nil {
		log.Fatal("Failed to run OpenVINO process:", err)
	}
}
