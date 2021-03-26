#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

# shellcheck disable=SC1091
source /opt/intel/openvino_2021/bin/setupvars.sh
export LD_LIBRARY_PATH=/opt/intel/openvino_2021/deployment_tools/inference_engine/samples/cpp/build/intel64/Release/lib:$LD_LIBRARY_PATH
/home/openvino/inference_engine_samples_build/intel64/Release/benchmark_app -i "${IMAGE}" -m "${MODEL}" -d "${TARGET_DEVICE}" -nireq "${NIREQ}" -api "${API}" -b "${BATCH_SIZE}"

