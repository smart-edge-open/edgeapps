// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2019 Intel Corporation

package main

import (
	"io"
	"log"
	"os"
	"os/exec"
	"strconv"
	"strings"
)

// OpenVINO acceleration types
const (
	CPU    = "CPU"
	MYRIAD = "MYRIAD"
	HDDL   = "HDDL"
)

var cmd *exec.Cmd

func checkEnvVariable(number string) {

	_, err := strconv.Atoi(number)
	if err != nil {
		log.Fatal("The invalid environment variable: OPENVINO_TASKSET_CPU")
	}
}

func callOpenVINO(model string, accl string, cpuset string) {

	var modelXML string
	// validate accelerator type
	switch accl {
	case CPU:
		modelXML = model + "/FP32/" + model + ".xml"
	case MYRIAD:
	case HDDL:
		modelXML = model + "/FP16/" + model + ".xml"
	default:
		log.Println("ERROR: uknown acceleration type (" + accl + ")")
		return
	}

	// kill already running process if not the first time
	if cmd != nil && cmd.Process != nil {
		if err := cmd.Process.Kill(); err != nil {
			log.Fatal("Failed to kill OpenVINO process:", err)
		}
		_ = cmd.Wait()
	}

	openvinoPath := os.Getenv("APP_DIR")
	openvinoCmd := "object_detection_demo_ssd_async.py"

	checkEnvVariable(cpuset)

	if err := os.Chdir(openvinoPath); err != nil {
		log.Fatal("Failed to change directory:", err)
	}

	cmd = exec.Command("taskset", "-c", cpuset,
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

	if err := cmd.Start(); err != nil {
		log.Fatal("Failed to run OpenVINO process:", err)
	}
}
