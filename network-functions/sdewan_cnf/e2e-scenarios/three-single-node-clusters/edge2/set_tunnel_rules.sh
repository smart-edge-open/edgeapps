#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

# setup rules for cnf on edge2

CNFPOD=$(kubectl get pod -l sdewanPurpose=sdewan-cnf -o name)
kubectl exec -it  "$CNFPOD" -- ip route

# These command just to set provider route SNAT rule.
NET2_IFC=net2
TO_SOURCE=${EDGE2_CNF_NET4_IFIP?"Error: not set"}
kubectl exec -it -n "${NS:-default}" "$CNFPOD" -- iptables -t nat -A POSTROUTING -o "$NET2_IFC" -s "$UE2_P1" -j SNAT --to-source "$TO_SOURCE"

# These command just to set ovelay route SNAT rule.
# NET3_IFC=net3
# find the overlay IP allocated by tunnel.
IPNET=$(kubectl exec -it -n "${NS:-default}" "$CNFPOD" -- ip a | grep "${O_UE2_IP%.*}" | awk '{match($0, /.+inet\s([^ ]*)/, a);print a[1];exit}')
# SNAT, UE2 IP of p1 interface map to overlay IP of EDGE2 net3 interface
TO_SOURCE=${IPNET%%/*}    # TO_SOURCE=$O_UE2_IP
kubectl exec -it -n "${NS:-default}" "$CNFPOD" -- iptables -t nat -A POSTROUTING -o "$NET2_IFC" -s "$UE2_P1" -j SNAT --to-source "$TO_SOURCE"
# If bidirectional need, then need DNAT
kubectl exec -it -n "${NS:-default}" "$CNFPOD" -- iptables -t nat -I PREROUTING -d "${IPNET%%/*}" -j DNAT --to-destination "$UE2_P1"

# watch the status by this command
# watch -n 1 kubectl exec -it  "$CNFPOD" -- iptables -t nat -L -n --line -v

# route to NET3
NET=${NET3?"Error: not set"}
VIA=${HUB_CNF_NET4_IFIP?"Error: not set"}
INTERFACE=net3
kubectl exec -it "$CNFPOD" -- ip r a "$NET" via "$VIA" dev "$INTERFACE"
