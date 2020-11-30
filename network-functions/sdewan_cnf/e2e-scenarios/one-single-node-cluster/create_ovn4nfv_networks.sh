#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

## Provider network 0
# Network name
PROV_0_NAME=${PROV_0_NAME}
PROV_0_SUB_0=${PROV_0_SUB_0}
PROV_0_SUB_0_NAME=${PROV_0_SUB_0_NAME}
PROV_0_SUB_0_GW=${PROV_0_SUB_0_GW}
PROV_0_SUB_0_EXCL=${PROV_0_SUB_0_EXCL}
PROV_0_INTF=${PROV_0_INTF}

LOCAL_0_NAME=${LOCAL_0_NAME}
LOCAL_0_SUB_0=${LOCAL_0_SUB_0}
LOCAL_0_SUB_0_NAME=${LOCAL_0_SUB_0_NAME}
LOCAL_0_SUB_0_GW=${LOCAL_0_SUB_0_GW}
LOCAL_0_SUB_0_EXCL=${LOCAL_0_SUB_0_EXCL}

#export IPERF_POD_OVN_INTF=net0
#export IPERF_POD_OVN_IP=172.16.30.15


cat > ovn4nfv_networks.yml << EOF

---

apiVersion: k8s.plugin.opnfv.org/v1alpha1
kind: ProviderNetwork
metadata:
  name: ${PROV_0_NAME}
spec:
  cniType: ovn4nfv
  ipv4Subnets:
  - subnet: ${PROV_0_SUB_0}
    name: ${PROV_0_SUB_0_NAME}
    gateway: ${PROV_0_SUB_0_GW}
    excludeIps: ${PROV_0_SUB_0_EXCL}
  providerNetType: DIRECT
  direct:
    providerInterfaceName: ${PROV_0_INTF}
    directNodeSelector: all

---

apiVersion: k8s.plugin.opnfv.org/v1alpha1
kind: Network
metadata:
  name: ${LOCAL_0_NAME}
spec:
  cniType: ovn4nfv
  ipv4Subnets:
  - subnet: ${LOCAL_0_SUB_0}
    name: ${LOCAL_0_SUB_0_NAME}
    gateway: ${LOCAL_0_SUB_0_GW}
    excludeIps: ${LOCAL_0_SUB_0_EXCL}
EOF
