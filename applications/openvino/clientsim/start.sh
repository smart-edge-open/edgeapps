#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2019 Intel Corporation

trap "exit" SIGINT SIGTERM
set -m
./tx_video.sh &
sleep 3
taskset -c 1 ffplay -i rtmp://openvino.openness/live/out.flv
fg
