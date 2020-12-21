#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# Copyright © 2020 Intel Corporation.


emcoctl --config emco_cfg.yaml delete -v values.yaml -f 04_apps_template.yaml 
emcoctl --config emco_cfg.yaml delete -v values.yaml -f 03_logical_cloud_template.yaml
sleep 3
emcoctl --config emco_cfg.yaml delete -v values.yaml -f 02_project_template.yaml
emcoctl --config emco_cfg.yaml delete -v values.yaml -f 01_clusters_template.yaml
