#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

wget - "https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml"

INTERVAL=15s
sed -i -e '/containers:/{:a; N; /.*- args:/!ba; a\        - --kubelet-insecure-tls\n        - --metric-resolution='"$INTERVAL"'' -e '}' components.yaml

kubectl apply -f components.yaml
