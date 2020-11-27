# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

FROM centos:7.8.2003

RUN yum update -y
RUN yum install -y iperf3 net-tools tcpdump ethtool wget python3 iproute traceroute vim nmap

WORKDIR /root/

COPY ./client_iperf.sh ./

CMD ["./client_iperf.sh"]
