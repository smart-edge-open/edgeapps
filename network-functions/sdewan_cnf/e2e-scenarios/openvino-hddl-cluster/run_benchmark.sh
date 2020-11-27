# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation
#!/bin/bash

# Build benchmark image and run

# build image
cd edgeapps/applications/openvino/benchmark/
sh build_image.sh
cd -

# setup benchmark_job yaml file
YAMLFILE=edgeapps/applications/openvino/benchmark/benchmark_job.yaml
sed -i -e "s/\(TARGET_DEVICE=\).*/\1${TARGET_DEVICE}/" $YAMLFILE
sed -i -e "s@\(IMAGE=\).*@\1${IMAGE}@" $YAMLFILE
sed -i -e "s@\(MODEL=\).*@\1${MODEL}@" $YAMLFILE
sed -i -e "s/\(API=\).*/\1${API}/" $YAMLFILE

# run benchmark_job
kubectl apply -f $YAMLFILE
