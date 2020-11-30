#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

# setup rules for cnf on edge1

CNFPOD=$(kubectl get pod -l sdewanPurpose=sdewan-cnf -o name)
kubectl exec -it  "$CNFPOD" -- ip route

kubectl exec -it  "$CNFPOD" -- ip rule add nat "$UE1_P1" via "$EDGE1_CNF_NET1_IFIP"
kubectl exec -it  "$CNFPOD" -- ip route show table all | grep ^nat
kubectl exec -it  "$CNFPOD" -- ip rule show
