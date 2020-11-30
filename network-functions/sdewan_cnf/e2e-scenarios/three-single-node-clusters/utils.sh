#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

# Provide the function to config interface

# generage the interface config file
# The first parameter is interface name, if not pass, then get from evn variable IPADDR
# The second is the ip address for the interface， if not pass, then get from evn variable IPADDR
function genifcfg()
{
    cat > /etc/sysconfig/network-scripts/ifcfg-"${1:-$INTERFACE}" << EOF
DEVICE=${1:-$INTERFACE}
BOOTPROTO=none
ONBOOT=yes
PREFIX=${PREFIX:-24}
IPADDR=${2:-$IPADDR}
# GATEWAY=192.168.3.1
EOF

    ip a s "${1:-$INTERFACE}"
    systemctl restart network
    ip a s "${1:-$INTERFACE}"
}
