#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2019 Intel Corporation

while :
do
  taskset -c 1 ffmpeg -re -async 1 -vsync -1 -f mjpeg -r 30 -i vidfifo.mjpeg \
    -vcodec mjpeg -b:v 50M -s 1280x720 -c:v copy \
    -pkt_size 1200 -f rtp rtp://analytics.openness:5001 > \
    /dev/null 2>&1 < /dev/null
done
