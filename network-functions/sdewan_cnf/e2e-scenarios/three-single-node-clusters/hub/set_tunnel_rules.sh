#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

# setup rules for cnf on hub

CNFPOD=$(kubectl get pod -l sdewanPurpose=sdewan-cnf -o name)
kubectl exec -it "$CNFPOD" -- ip route
kubectl exec -it "$CNFPOD" -- ip route add "${HUB_CNF_NET4_IFIP}"/32 dev "$PNET_IFC"
kubectl exec -it "$CNFPOD" -- ip route add "${HUB_CNF_NET3_IFIP}"/32 dev "$ONET_IFC"
