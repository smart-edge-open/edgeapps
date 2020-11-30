#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

# Provide the interface for the server to start on
interface="eno1"

if [ -z "$interface" ]
then
  echo -e "\tThe interface for the Iperf server to listen on is not set"
  exit 1
fi

server_ip=$(ifconfig $interface | grep inet | awk '{print $2}')

echo "iperf3 server is starting at IP: $server_ip"

iperf3 -s "$server_ip" -i 60

echo "Iperf3 server is stopped"
