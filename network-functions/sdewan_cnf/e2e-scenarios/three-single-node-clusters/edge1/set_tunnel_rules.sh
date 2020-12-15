#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

# setup rules for cnf on edge1

CNFPOD=$(kubectl get pod -l sdewanPurpose=sdewan-cnf -o name)
kubectl exec -it  "$CNFPOD" -- ip route

# These command just to set provider route DNAT rule.
FROM_ADDR=${EDGE1_CNF_NET3_IFIP?"Error: not set"}
NET=${NET3?"Error: not set"}
TO_ADDR=${UE1_P1?"Error: not set"}
DEV=$(kubectl exec -it -n "${NS:-default}" "$CNFPOD" -- ip route get "$NET" | awk '{match($0, /.+dev\s([^ ]+)/, a);print a[1];exit}')
kubectl exec -it -n "${NS:-default}" "$CNFPOD" -- iptables -t nat -I PREROUTING -i "$DEV" -d "$FROM_ADDR" -j DNAT --to-destination "$TO_ADDR"

# These command just to set ovelay route DNAT rule.
# NET3_IFC=net3
IPNET=$(kubectl exec -it -n "${NS:-default}" "$CNFPOD" -- ip a | grep "${O_UE2_IP%.*}" | awk '{match($0, /.+inet\s([^ ]*)/, a);print a[1];exit}')
# DNAT
FROM_ADDR=${IPNET%%/*}    # FROM_ADDR=$O_UE1_IP
kubectl exec -it -n "${NS:-default}" "$CNFPOD" -- iptables -t nat -I PREROUTING -i "$DEV" -d "$FROM_ADDR" -j DNAT --to-destination "$TO_ADDR"
# If bidirectional need, then need SNAT
kubectl exec -it -n "${NS:-default}" "$CNFPOD" -- iptables -t nat -A POSTROUTING -s "$TO_ADDR" -j SNAT --to-source "$FROM_ADDR"


# route to NET4
NET=${NET4?"Error: not set"}
VIA=${HUB_CNF_NET3_IFIP?"Error: not set"}
INTERFACE=net3
kubectl exec -it "$CNFPOD" -- ip r a "$NET" via "$VIA" dev "$INTERFACE"

# watch the status by this command
# watch -n 1 kubectl exec -it  "$CNFPOD" -- iptables -t nat -L -n --line -v
