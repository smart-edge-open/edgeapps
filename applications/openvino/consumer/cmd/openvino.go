// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2019 Intel Corporation

package main

import (
	"io"
	"log"
	"os"
	"os/exec"
	"sync"
)

// OpenVINO acceleration types
const (
	CPU    = "CPU"
	MYRIAD = "MYRIAD"
	HDDL   = "HDDL"
)

var cmd *exec.Cmd

func callOpenVINO(model string, accl string) {

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
	if cmd != nil {
		if err := cmd.Process.Kill(); err != nil {
			log.Fatal("Failed to kill OpenVINO process:", err)
		}
		_ = cmd.Wait()
	}

	openvinoPath := os.Getenv("APP_DIR")
	openvinoCmd := "object_detection_demo_ssd_async.py"

	if err := os.Chdir(openvinoPath); err != nil {
		log.Fatal("Failed to change directory:", err)
	}

	cmd = exec.Command("python3", openvinoCmd, "-d", accl,
				"-i", "rtmp://127.0.0.1:5000/live/test.flv",
				"-m", modelXML)

	stdout, _ := cmd.StdoutPipe()
	stderr, _ := cmd.StderrPipe()

	var wg sync.WaitGroup
	wg.Add(2)

	go func() {
		if _, err := io.Copy(os.Stdout, stdout); err != nil {
			log.Println(err)
		}
		wg.Done()
	}()
	go func() {
		if _, err := io.Copy(os.Stderr, stderr); err != nil {
			log.Println(err)
		}
		wg.Done()
	}()

	if err := cmd.Start(); err != nil {
		log.Fatal("Failed to run OpenVINO process:", err)
	}

	wg.Wait()

	if err := cmd.Wait(); err != nil {
		log.Println(err)
	}
}
