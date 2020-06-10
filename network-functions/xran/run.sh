#!/bin/bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

sudo docker build \
    --build-arg http_proxy=$http_proxy \
    --build-arg https_proxy=$https_proxy \
    --build-arg ftp_proxy=$ftp_proxy \
    --build-arg no_proxy=$no_proxy \
    -t xran-sample-app:1.0 . 
