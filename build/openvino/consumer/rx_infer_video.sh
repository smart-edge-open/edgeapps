#!/bin/bash
#########################################################
# Copyright 2019 Intel Corporation. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#########################################################

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/root/inference_engine_samples_build/intel64/Release/lib/
source /opt/intel/openvino/bin/setupvars.sh

# Run inference
echo "Execute inference on incoming UDP video stream..."
taskset -c 1 ./simple_stream -i udp://@:10001?overrun_nonfatal=1 -m /opt/intel/computer_vision_sdk/deployment_tools/intel_models/pedestrian-detection-adas-0002/FP32/pedestrian-detection-adas-0002.xml -show -fr -1
