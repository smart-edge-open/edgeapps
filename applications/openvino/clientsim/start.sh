#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2019 Intel Corporation

trap "exit" SIGINT SIGTERM
set -m
./tx_video.sh &
sleep 4
taskset -c 1 ffplay -i rtmp://127.0.0.1/live/out.flv 
fg
