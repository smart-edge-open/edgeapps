#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

# setup the networks topology on all hosts of e2e scenarios

cat >> ~/.profile << EOF
export PREFIX=24

export NET1=192.168.3.0/24
export UE1_P1=192.168.3.4
export EDGE1_P1=172.168.3.5
export EDGE1_CNF_NET1_IFIP=192.168.3.7

export NET2=192.168.4.0/24
export UE2_P1=192.168.4.4
export EDGE2_P1=172.168.4.5
export EDGE2_CNF_NET2_IFIP=192.168.4.7

export NET3=10.10.10.0/24
export HUB_P1=11.10.10.4
export EDGE1_P2=11.10.10.5
export HUB_CNF_NET3_IFIP=10.10.10.6
export EDGE1_CNF_NET3_IFIP=10.10.10.7

export NET4=10.10.20.0/24
export HUB_P2=11.10.20.4
export EDGE2_P2=11.10.20.5
export HUB_CNF_NET4_IFIP=10.10.20.6
export EDGE2_CNF_NET4_IFIP=10.10.20.7

# overlay net,  no OIP for HUB
export O_TUNNEL1_NET=172.16.30.0/24
export NS=cnf

EOF

source ~/.profile
