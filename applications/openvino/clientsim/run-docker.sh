#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2019 Intel Corporation

if [ $? -ne 1 ]; then
    echo "Usage: $0 \$POD_IP"
    exit 1
fi

sudo docker run --rm --name client-sim \
    --network host -e DISPLAY \
    -e QT_X11_NO_MITSHM=1 \
    -e POD_IP=$2 \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -v /root/.Xauthority:/root/.Xauthority \
    --cpuset-cpus="1,2" \
    -t client-sim:1.0
