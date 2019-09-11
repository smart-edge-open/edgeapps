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

var cmd *exec.Cmd

func callOpenVINO(modelName string, modelAccl string) {
	var err error

	// kill already running process if not the first time
	if cmd != nil {
		err = cmd.Process.Kill()
		if err != nil {
			log.Fatal("Failed to kill OpenVINO process:", err)
		}
		_ = cmd.Wait()
	}

	var openvinoPath = "/root/inference_engine_samples_build/intel64/Release/"
	var openvinoCmd = "object_detection_sample_ssd"

	// #nosec
	cmd = exec.Command("taskset", "-c", "2",
		openvinoPath+openvinoCmd, "-d", modelAccl,
		"-i", "rtp://127.0.0.1:5000?overrun_nonfatal=1",
		"-m", (modelName + "/FP32/" + modelName + ".xml"))

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
