#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

# setup rules for cnf on hub

CNFPOD=$(kubectl get pod -l -n "$NS" sdewanPurpose=sdewan-cnf -o name)
kubectl exec -it "$CNFPOD" -n "$NS" -- ip route
