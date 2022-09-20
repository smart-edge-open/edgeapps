#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2019 Intel Corporation

trap "exit" SIGINT SIGTERM

while :
do
  taskset -c 2 taskset -c 2 ffmpeg -re -i Rainy_Street.mp4 -c:v copy -an -f flv rtmp://openvino.openness:5000/live/test.flv > \
  /dev/null 2>&1 < /dev/null
done
