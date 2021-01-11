#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2019 Intel Corporation

source $OPENVINO_ROOT/bin/setupvars.sh
echo "192.168.1.10 analytics.openness" >> /etc/hosts
nginx -g "daemon on;"
./main
