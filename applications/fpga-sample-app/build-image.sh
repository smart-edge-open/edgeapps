#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2019 Intel Corporation

BBDEV_PATCH=./dpdk_19.11_new.patch

##Check for existance of BBDEV v19.10 patch for DPDK 18.08
if test -f "$BBDEV_PATCH"; then
    echo "BBDEV patch found"
else
    echo "$BBDEV_PATCH does not exist." \
	   "Please place the BBDEV patch for DPDK 19.11 into root directory of this script.\n" \
	   "The patch is provided as part of v19.12 Release of FlexRAN package.\n" \
	   "The script will now exit, the image will not be created.\n"
    exit
fi

sudo docker build \
    --build-arg http_proxy=$http_proxy \
    --build-arg https_proxy=$https_proxy \
    --build-arg no_proxy=$no_proxy \
    -t bbdev-sample-app:1.0 .

