#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2019 Intel Corporation

trap "exit" SIGINT SIGTERM

while :
do
  taskset -c 2 ffmpeg -re -i Rainy_Street.mp4 -pix_fmt yuvj420p \
    -vcodec mjpeg -map 0:0 -pkt_size 1200 -f rtp rtp://openvino.openness:5000 > \
    /dev/null 2>&1 < /dev/null
done
