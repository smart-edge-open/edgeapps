#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

# setup rules for cnf on edge2 by CR


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

IPNET=$(kubectl exec -it  "$CNFPOD" -- ip a | grep "${O_TUNNEL1_NET%.*}" | awk '{match($0, /.+inet\s([^ ]*)/, a);print a[1];exit}')
FROM_ADDR=${UE2_P1?"Error: not set"}
TO_ADDR=${IPNET%%/*}
# DESTINATION='""'

#Adding SNAT rules
cat > sdwanSNATConfigs.yaml << EOF
apiVersion: batch.sdewan.akraino.org/v1alpha1
kind: FirewallSNAT
metadata:
  name: firewallsnat
  namespace: ${NS:-default}
  labels:
    sdewanPurpose: ${sdewan_cnf_name:-sdewan-cnf}
spec:
  src_ip: $FROM_ADDR
  src_dip: $TO_ADDR
  dest: $ZONEANME
  dest_ip: ${TO_ADDR}/24
  proto: all
  target: SNAT
EOF

kubectl apply -f sdwanSNATConfigs.yaml
kubectl get firewallsnat firewallsnat  -n "${NS:-default}" -o=custom-columns='NAME:metadata.name,MESSAGE:status.message,STATUS:status.state'
