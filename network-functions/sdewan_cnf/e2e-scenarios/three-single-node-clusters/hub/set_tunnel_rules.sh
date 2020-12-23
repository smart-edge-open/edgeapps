#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

# setup rules for cnf on hub

CNFPOD=$(kubectl get pod -l sdewanPurpose=sdewan-cnf -o name)
kubectl exec -it "$CNFPOD" -- ip route
