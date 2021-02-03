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
	if cmd != nil {
		err := cmd.Process.Kill()
		if err != nil {
			log.Fatal("Failed to kill OpenVINO process:", err)
		}
		_ = cmd.Wait()
	}

	var openvinoPath = "/root/omz_demos_build/intel64/Release/"
	var openvinoCmd = "object_detection_demo_ssd_async"

	var modelXML string
	if accl == CPU {
		modelXML = model + "/FP32/" + model + ".xml"
	} else {
		modelXML = model + "/FP16/" + model + ".xml"
	}

	// get taskset cpu from env
	openvinoTasksetCPU := os.Getenv("OPENVINO_TASKSET_CPU")

	// #nosec
	cmd = exec.Command("taskset", "-c", openvinoTasksetCPU,
		openvinoPath+openvinoCmd, "-d", accl,
		"-i", "rtp://127.0.0.1:5000?overrun_nonfatal=1",
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
