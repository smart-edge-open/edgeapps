#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# Copyright © 2020 Intel Corporation.


emcoctl --config emco_cfg.yaml delete -v values.yaml -f 04_del_template.yaml 
emcoctl --config emco_cfg.yaml delete -v values.yaml -f 03_del_cloud_template.yaml
sleep 3
emcoctl --config emco_cfg.yaml delete -v values.yaml -f 01_del_template.yaml
emcoctl --config emco_cfg.yaml delete -v values.yaml -f 02_project_template.yaml
