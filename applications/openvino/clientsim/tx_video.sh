#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2019 Intel Corporation

trap "exit" SIGINT SIGTERM

while :
do
  taskset -c 2 taskset -c 2 ffmpeg -re -i Rainy_Street.mp4 -c:v copy -s 1280x720 -an -f flv rtmp://127.0.0.1/live/test.flv > \
  /dev/null 2>&1 < /dev/null
done
