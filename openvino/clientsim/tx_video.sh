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

trap "exit" SIGINT SIGTERM

while :
do
  taskset -c 2 ffmpeg -re -i Rainy_Street.mp4 -pix_fmt yuvj420p \
    -vcodec mjpeg -map 0:0 -pkt_size 1200 -f rtp rtp://openvino.openness:5000 > \
    /dev/null 2>&1 < /dev/null
done
