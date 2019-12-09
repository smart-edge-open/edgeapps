// Copyright 2019 Intel Corporation. All rights reserved.
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
	"io"
	"log"
	"os"
	"os/exec"
)

// OpenVINO acceleration types
const (
	CPU    = "CPU"
	MYRIAD = "MYRIAD"
	HDDL   = "HDDL"
)

var cmd *exec.Cmd

func callOpenVINO(model string, accl string) {
	var err error

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
		err = cmd.Process.Kill()
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

	// #nosec
	cmd = exec.Command("taskset", "-c", "2",
		openvinoPath+openvinoCmd, "-d", accl,
		"-i", "rtp://127.0.0.1:5000?overrun_nonfatal=1",
		"-m", modelXML)

	stdout, _ := cmd.StdoutPipe()
	stderr, _ := cmd.StderrPipe()
	go func() {
		if _, err = io.Copy(os.Stdout, stdout); err != nil {
			log.Println(err)
		}
	}()
	go func() {
		if _, err = io.Copy(os.Stderr, stderr); err != nil {
			log.Println(err)
		}
	}()

	err = cmd.Start()
	if err != nil {
		log.Fatal("Failed to run OpenVINO process:", err)
	}
}
