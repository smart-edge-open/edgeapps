#!/bin/bash
#########################################################
# Copyright 2019 Intel Corporation. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#########################################################

BBDEV_PATCH=./flexran-dpdk-bbdev-v19-10.patch

#Check for existance of BBDEV v19.10 patch for DPDK 18.08
if test -f "$BBDEV_PATCH"; then
    echo "BBDEV patch found"
else
    echo "$BBDEV_PATCH does not exist." \
	   "Please place the BBDEV patch for DPDK 18.08 into root directory of this script.\n" \
	   "The patch is provided as part of v19.10 Release of FlexRAN package.\n" \
	   "The script will now exit, the image will not be created.\n"
    exit
fi

sudo docker build \
    --build-arg http_proxy=$http_proxy \
    --build-arg https_proxy=$https_proxy \
    --build-arg no_proxy=$no_proxy \
    -t bbdev-sample-app:1.0 .

