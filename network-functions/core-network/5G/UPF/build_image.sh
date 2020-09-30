#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

declare http_proxy https_proxy no_proxy
sudo docker build \
    --build-arg http_proxy="$http_proxy" \
    --build-arg https_proxy="$https_proxy" \
    --build-arg no_proxy="$no_proxy" \
    -t upf-cnf:1.0 .
