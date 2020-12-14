#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# Copyright © 2020 Intel Corporation.

# This will be fixed by emco team
# update rsync port !!!!!
# kubectl get service -n emco | grep "rsync" | awk '{match($0, /.+:([0-9]+)\/TCP.+/, a);print a[1]}' | xargs -I{} sed -i "s/RsyncPort:.*/RsyncPort: {}/g" values.yaml
# RsyncPort=`kubectl get service -n emco | grep "rsync" | awk '{match($0, /.+:([0-9]+)\/TCP.+/, a);print a[1]}'`
# sed -i "s/RsyncPort:.*/RsyncPort: $RsyncPort/g" values.yaml
# echo "rsync port is $RsyncPort"
# update gac port !!!!!
# kubectl get service -n emco | grep "gac" | awk '{match($0, /.+9033:([0-9]+)\/TCP.+/, a);print a[1]}' | xargs -I{} sed -i "s/GacPort:.*/GacPort: {}/g" values.yaml
# GacPort=`kubectl get service -n emco | grep "gac" | awk '{match($0, /.+9033:([0-9]+)\/TCP.+/, a);print a[1]}'`
# sed -i "s/GacPort:.*/GacPort: $GacPort/g" values.yaml
# echo "gac port is $GacPort"

emcoctl --config emco_cfg.yaml apply -v values.yaml -f 01_clusters_template.yaml
