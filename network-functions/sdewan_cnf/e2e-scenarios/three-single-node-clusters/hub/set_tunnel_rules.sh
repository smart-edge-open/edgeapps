#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

# setup rules for cnf on hub

CNFPOD=$(kubectl get pod -l sdewanPurpose=sdewan-cnf -o name)
kubectl exec -it "$CNFPOD" -- ip route
kubectl exec -it "$CNFPOD" -- bash -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
kubectl exec -it "$CNFPOD" -- bash -c "cat /proc/sys/net/ipv4/ip_forward"
