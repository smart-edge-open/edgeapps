#!/bin/bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation



set -e

echo "[Starting cleaning]"

rm -rf Smart-City-Sample
rm -rf /opt/openness/smtc_edge_helmchart.tar.gz
rm -rf /opt/openness/smtc_cloud_helmchart.tar.gz
rm -rf /opt/openness/smtc_edge_profile.tar.gz
rm -rf /opt/openness/smtc_cloud_profile.tar.gz
rm -rf /opt/openness/clusters_config
rm -rf /opt/openness/sensor-info.json

echo "Cleaning Successfully."
exit 0
