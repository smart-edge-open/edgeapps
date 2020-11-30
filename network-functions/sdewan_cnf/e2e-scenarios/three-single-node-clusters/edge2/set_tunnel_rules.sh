#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

# setup rules for cnf on edge2

CNFPOD=$(kubectl get pod -l sdewanPurpose=sdewan-cnf -o name)
kubectl exec -it  "$CNFPOD" -- ip route

kubectl exec -it  "$CNFPOD" -- ip rule add nat "$EDGE2_CNF_NET2_IFIP" from "$UE2_P1"
kubectl exec -it  "$CNFPOD" -- ip route show table all | grep ^nat
kubectl exec -it  "$CNFPOD" -- ip rule show
