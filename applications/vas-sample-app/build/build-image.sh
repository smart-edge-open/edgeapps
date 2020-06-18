#!/bin/bash

# PDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

sudo docker build -f ./build/Dockerfile \
    --build-arg http_proxy=$http_proxy \
    --build-arg https_proxy=$https_proxy \
    --build-arg no_proxy=$no_proxy \
    -t vas-cons-app:1.0 .
