#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

set -eu

helpPrint()
{
   echo ""
   echo "Usage: $0 <filename> <port_no>"
   echo -e "Example:"
   echo -e "    $0 /root/pcb_d2000.avi  8554"
   echo -e "    $0 /root/Safety_Full_Hat_and_Vest.avi  8554"  
   exit 1 # Exit with help
}

if [[ $# -ne 2 ]] ; then
    echo "No of argument are not correct"
    helpPrint
fi
name=$1
port=$2

pkill -9 cvlc
sleep 2

cvlc -vvv "$name" --sout ="#gather:rtp{sdp=rtsp://0.0.0.0:$port/}" --loop --sout-keep
