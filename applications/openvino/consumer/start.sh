#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2019 Intel Corporation

# shellcheck disable=SC1091
source "$OPENVINO_ROOT"/bin/setupvars.sh
nginx -g "daemon on;"
./main
