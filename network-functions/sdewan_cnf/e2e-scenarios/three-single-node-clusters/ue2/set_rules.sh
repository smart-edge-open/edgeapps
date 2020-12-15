#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

# setup rules for UE2

NET=${NET2?"Error: not set"}
INTERFACE=$(ip route get "$NET" | awk '{match($0, /.+dev\s([^ ]+)/, a);print a[1];exit}')
VIA=${EDGE2_CNF_NET2_IFIP?"Error: not set"}
ip route add "$NET4" via "$VIA" dev "$INTERFACE"
ip route add "$NET3" via "$VIA" dev "$INTERFACE"
ip route add "$O_TUNNEL1_NET" via "$VIA" dev "$INTERFACE"
