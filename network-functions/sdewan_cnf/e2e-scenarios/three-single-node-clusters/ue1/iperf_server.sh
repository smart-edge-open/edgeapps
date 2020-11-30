#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

# Provide the interface for the server to start on

interface=$(ip route |grep "${NET1%/*}" | awk '{match($0, /.+dev\s([^ ]*)/, a);print a[1];exit}')

if [ -z "$interface" ]
then
  echo -e "\tThe interface for the Iperf server to listen on is not set"
  exit 1
fi

server_ip=$UE1_P1

echo "iperf3 server is starting at IP: $server_ip, and maps to a floating IP: $EDGE1_CNF_NET1_IFIP"
echo "Access iperf3 server, please use floating IP: $EDGE1_CNF_NET1_IFIP"

#iperf3 -s "$server_ip" -i 60

echo "iperf3 server is stopped"
