#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

# Modify the iperf-server IP as per the setup
server_ip=192.168.2.2

# Modify interface name (net0) if needed
client_ip=$(ifconfig net0 | grep inet | awk '{print $2}')

duration=300
streams=1
pkt_size=128

# Start Iperf client to send TCP stream towards Iperf server
echo "Iperf client started sending TCP packet stream"
echo "server_ip=$server_ip, client_ip=$client_ip, duration=$duration, streams=$streams, packet_size=$pkt_size"

iperf3 -c "$server_ip" -B "$client_ip" -J -b 0 -t "$duration" -P "$streams" -M "$pkt_size" -l 1M

echo "Stopped Iperf TCP streaming"
