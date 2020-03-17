#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2019 Intel Corporation

sudo docker run --rm --name client-sim \
    --network host -e DISPLAY \
    -e QT_X11_NO_MITSHM=1 \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -v /root/.Xauthority:/root/.Xauthority \
    --cpuset-cpus="1,2" \
    -t client-sim:1.0
