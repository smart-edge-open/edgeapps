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

var infCmd *exec.Cmd
var fwCmd *exec.Cmd

func objectDetection(modelName string) {
	var err error

	// kill already running process if not the first time
	if infCmd != nil {
		err = infCmd.Process.Kill()
		if err != nil {
			log.Fatal("Failed to kill process:", err)
		}

		err = fwCmd.Process.Kill()
		if err != nil {
			log.Fatal("Failed to kill process:", err)
		}
	}

	var openvinoPath = "/root/inference_engine_samples_build/intel64/Release/"
	var openvinoCmd = "object_detection_demo_ssd_async"

	// #nosec
	infCmd = exec.Command("taskset", "-c", "1",
		openvinoPath+openvinoCmd,
		"-i", "udp://@:10001?overrun_nonfatal=1",
		"-m", (modelName + "/FP32/" + modelName + ".xml"))

	// #nosec
	fwCmd = exec.Command("taskset", "-c", "0",
		"ffmpeg", "-re", "-async", "1", "-vsync", "-1",
		"-f", "mjpeg", "-r", "30", "-i", "vidfifo.mjpeg", "-vcodec",
		"mjpeg", "-b:v", "50M", "-s", "1280x720", "-c:v", "copy",
		"-f", "rtp", "rtp://analytics.community.appliance.mec:9999")

	stdout, _ := infCmd.StdoutPipe()
	stderr, _ := infCmd.StderrPipe()
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

	stdout1, _ := fwCmd.StdoutPipe()
	stderr1, _ := fwCmd.StderrPipe()
	go func() {
		if _, err = io.Copy(os.Stdout, stdout1); err != nil {
			log.Println(err)
		}
	}()
	go func() {
		if _, err = io.Copy(os.Stderr, stderr1); err != nil {
			log.Println(err)
		}
	}()

	err = infCmd.Start()
	if err != nil {
		log.Fatal("Failed to run OpenVINO app:", err)
	}

	err = fwCmd.Start()
	if err != nil {
		log.Fatal("Failed to run Forwarder app:", err)
	}
}
