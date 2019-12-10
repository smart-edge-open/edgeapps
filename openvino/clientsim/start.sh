#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2019 Intel Corporation

trap "exit" SIGINT SIGTERM
set -m
./tx_video.sh &
sleep 2
taskset -c 1 ffplay -reorder_queue_size 0 -i downstream.sdp 
fg
