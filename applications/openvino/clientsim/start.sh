#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2019 Intel Corporation

trap "exit" SIGINT SIGTERM
./tx_video.sh &

while true
do
  taskset -c 1 ffplay -i rtmp://openvino.openness:5000/live/out.flv -an
done
