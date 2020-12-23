#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# Copyright © 2020 Intel Corporation.

emcoctl --config emco_cfg.yaml apply -v values.yaml -f 88_terminate_template.yaml

echo "wait 5 seconds here!"
sleep 5
echo "back again~"
