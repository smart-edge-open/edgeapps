#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

# setup rules for cnf on edge1 by CR


ZONEANME=${ONET_NAME:-pnetwork2}

echo "--------------------- Adding firewall rules ---------------------"
cat > firewall_zone_1.yaml << EOF
apiVersion: batch.sdewan.akraino.org/v1alpha1
kind: FirewallZone
metadata:
  name: $ZONEANME
  namespace: ${NS:-default}
  labels:
    sdewanPurpose: ${sdewan_cnf_name:-sdewan-cnf}
spec:
  network:
    - $ZONEANME
  input: ACCEPT
  output: ACCEPT
  forward: ACCEPT
  masq: "0"
  mtu_fix: "1"
EOF

kubectl apply -f firewall_zone_1.yaml
kubectl get firewallzone "$ZONEANME" -n "${NS:-default}" -o=custom-columns='NAME:metadata.name,MESSAGE:status.message,STATUS:status.state'

CNFPOD=$(kubectl get pod -l sdewanPurpose=sdewan-cnf -n "$NS" -o name)
IPNET=$(kubectl exec -it -n "${NS:-default}" "$CNFPOD" -- ip a | grep "${O_TUNNEL1_NET%.*}" | awk '{match($0, /.+inet\s([^ ]*)/, a);print a[1];exit}')
FROM_ADDR=${IPNET%%/*}
TO_ADDR=${UE1_P1?"Error: not set"}
# SOURCE='""'

#Adding DNAT...
cat > sdwanDNATConfigs.yaml << EOF
apiVersion: batch.sdewan.akraino.org/v1alpha1
kind: FirewallDNAT
metadata:
  name: firewalldnat
  namespace: ${NS:-default}
  labels:
    sdewanPurpose: ${sdewan_cnf_name:-sdewan-cnf}
spec:
  src: $ZONEANME
  src_ip: ${FROM_ADDR}/24
  src_dip: $FROM_ADDR
  dest_ip: $TO_ADDR
  proto: all
  target: DNAT
EOF

kubectl apply -f sdwanDNATConfigs.yaml
kubectl get firewalldnat firewalldnat -n "${NS:-default}" -o=custom-columns='NAME:metadata.name,MESSAGE:status.message,STATUS:status.state'
