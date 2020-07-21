#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation
name="/tmp/pcb_d2000.avi";
sout="#gather:rtp{sdp=rtsp://0.0.0.0:8554/}"
su vlcuser -c "cvlc -vvv $name --sout '$sout' --loop --sout-keep"
