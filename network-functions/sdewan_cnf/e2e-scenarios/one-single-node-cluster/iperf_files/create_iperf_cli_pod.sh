#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

IPERF_POD_OVN_INTF=${IPERF_POD_OVN_INTF}
IPERF_POD_OVN_IP=${IPERF_POD_OVN_IP}

cat > iperf_cli_pod.yaml << EOF
---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: iperf-client
  labels:
    app: iperf-client
spec:
  replicas: 1
  selector:
    matchLabels:
      app: iperf-client
  template:
    metadata:
      labels:
        app: iperf-client
      annotations:
        k8s.v1.cni.cncf.io/networks: '[{ "name": "ovn-networkobj"}]'
        k8s.plugin.opnfv.org/nfn-network: '{ "type": "ovn4nfv", "interface": [{"name": "ovn-network", "interface": "$IPERF_POD_OVN_INTF", "ipAddress": "$IPERF_POD_OVN_IP"}]}'
    spec:
      containers:
      - name: iperf-client
        image: iperf-client:1.0
        imagePullPolicy: Never
        ports:
        - containerPort: 80
        - containerPort: 443
        securityContext:
          privileged: true
EOF
