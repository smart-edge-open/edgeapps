#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

# setup 2 provider networks for sdewan cnf
PNET1=$NET3
PNET2=$NET4
pNET1=$HUB_P1
pNET2=$HUB_P2
PNET1_IF=$(ip route |grep "$pNET1" | awk '{match($0, /.+dev\s([^ ]*)/, a);print a[1];exit}')
PNET2_IF=$(ip route |grep "$pNET2" | awk '{match($0, /.+dev\s([^ ]*)/, a);print a[1];exit}')
echo "$PNET1_IF"
echo "$PNET2_IF"

cat > networks-prepare.yaml << EOF
---
apiVersion: k8s.plugin.opnfv.org/v1alpha1
kind: ProviderNetwork
metadata:
  name: pnetwork1
spec:
  cniType: ovn4nfv
  ipv4Subnets:
  - subnet: $PNET1
    name: subnet
    gateway: ${PNET1/.0\//.1/}
    excludeIps: ${PNET1%.*}.2..${PNET1%.*}.9
  providerNetType: DIRECT
  direct:
    providerInterfaceName: $PNET1_IF
    directNodeSelector: all

---
apiVersion: k8s.plugin.opnfv.org/v1alpha1
kind: ProviderNetwork
metadata:
  name: pnetwork2
spec:
  cniType: ovn4nfv
  ipv4Subnets:
  - subnet: $PNET2
    name: subnet
    gateway: ${PNET2/.0\//.1/}
    excludeIps: ${PNET2%.*}.2..${PNET2%.*}.9
  providerNetType: DIRECT
  direct:
    providerInterfaceName: $PNET2_IF
    directNodeSelector: all
EOF

kubectl apply -f networks-prepare.yaml
