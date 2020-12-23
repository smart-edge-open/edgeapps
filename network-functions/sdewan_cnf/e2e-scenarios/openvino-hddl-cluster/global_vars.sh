#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

# This variables are used for hddl benchmark setting.
export MODEL1=/opt/intel/openvino/deployment_tools/open_model_zoo/tools/downloader/intel/face-detection-retail-0004/FP16/face-detection-retail-0004.xml
export MODEL2=/opt/intel/openvino/deployment_tools/open_model_zoo/tools/downloader/intel/semantic-segmentation-adas-0001/FP16/semantic-segmentation-adas-0001.xml
export MODEL3=/opt/intel/openvino/deployment_tools/open_model_zoo/tools/downloader/public/ssd300/FP16/ssd300.xml
export MODEL4=/opt/intel/openvino/deployment_tools/open_model_zoo/tools/downloader/public/ssd512/FP16/ssd512.xml
export MODEL5=/root/openvino_models/ir/public/squeezenet1.1/FP16/squeezenet1.1.xml

# target_device:  CPU, GPU, FPGA, HDDL or MYRIAD are acceptable
export TARGET_DEVICE=HDDL
export IMAGE=/opt/intel/openvino/deployment_tools/demo/car.png
# MODEL can be MODEL1， MODEL2， MODEL3， MODEL4， MODEL5
export MODEL=/opt/intel/openvino/deployment_tools/open_model_zoo/tools/downloader/public/ssd512/FP16/ssd512.xml
# API: sync/async
export API=async
export BATCH_SIZE=1
