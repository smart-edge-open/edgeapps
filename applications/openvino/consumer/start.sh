#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2019 Intel Corporation

# shellcheck disable=SC1091
echo "192.168.1.10 analytics.openness" >> /etc/hosts
source "$OPENVINO_ROOT"/bin/setupvars.sh
nginx -g "daemon on;"
./main
