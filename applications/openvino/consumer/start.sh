#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2019 Intel Corporation

# shellcheck disable=SC1091
source "$OPENVINO_ROOT"/bin/setupvars.sh
echo "192.168.1.10 analytics.openness" >> /etc/hosts
nginx -g "daemon on;"
./main
