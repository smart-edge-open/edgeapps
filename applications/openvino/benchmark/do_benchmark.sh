# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

#!/bin/bash -xe

source /opt/intel/openvino/bin/setupvars.sh
cd /opt/intel/openvino/deployment_tools/demo
./demo_squeezenet_download_convert_run.sh -d HDDL

/root/inference_engine_samples_build/intel64/Release/benchmark_app -i /opt/intel/openvino/deployment_tools/demo/car.png -m /root/openvino_models/ir/public/squeezenet1.1/FP16/squeezenet1.1.xml -d HDDL -nireq 32 -niter 9999999 -api async

