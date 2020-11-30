#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

## Provider network 0
# Network name
export PROV_0_NAME=pnetwork
# Subnet address
export PROV_0_SUB_0=192.168.2.1/24
# Sunbet name
export PROV_0_SUB_0_NAME=subnet
# Subnet gateway
export PROV_0_SUB_0_GW=192.168.2.1/24
# Subnet exclude IP addresses
export PROV_0_SUB_0_EXCL=192.168.2.2..192.168.2.9
# Interface on the host
export PROV_0_INTF=eno7

## Local OVN network 0
# Network name
export LOCAL_0_NAME=ovn-network
# Subnet address
export LOCAL_0_SUB_0=172.16.30.1/24
# Subnet name
export LOCAL_0_SUB_0_NAME=subnet1
# Subnet gateway
export LOCAL_0_SUB_0_GW=172.16.30.1/24
# Subnet exclude IP addresses
export LOCAL_0_SUB_0_EXCL=172.16.30.2..172.16.30.9

## Iperf-client pod network config
export IPERF_POD_OVN_INTF=net0
export IPERF_POD_OVN_IP=172.16.30.15

