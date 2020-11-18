#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

if [ "$#" -ne 2 ] ; then
    echo "No of argument are not correct"
    exit 1
fi

if [ "$1" = "pcb" ] 
then 
    echo "Set pcb demo rtsp stream file"
    name="/tmp/pcb_d2000.avi"
	
elif [ "$1" = "safety" ]
then
    echo "Set Safety Hat demo rtsp stream file"
    name="/tmp/Safety_Full_Hat_and_Vest.avi"

else
   echo "Wrong argument pass for rtsp stream demo"
   exit 1

fi 
sout="#gather:rtp{sdp=rtsp://0.0.0.0:$2/}"
su vlcuser -c "cvlc -vvv $name --sout '$sout' --loop --sout-keep"
