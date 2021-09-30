#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2019 Intel Corporation
declare http_proxy https_proxy no_proxy

if [ -z "$1" ];then
  sudo docker build \
    --build-arg http_proxy="$http_proxy" \
    --build-arg https_proxy="$https_proxy" \
    --build-arg no_proxy="$no_proxy" \
    -t openvino-cons-app:1.0 -f Dockerfile .
else
  sudo docker build \
    --build-arg http_proxy="$http_proxy" \
    --build-arg https_proxy="$https_proxy" \
    --build-arg no_proxy="$no_proxy" \
    -t openvino-cons-app:1.0 -f Dockerfile.pwek .
fi
