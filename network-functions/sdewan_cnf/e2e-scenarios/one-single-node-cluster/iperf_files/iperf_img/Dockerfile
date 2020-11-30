# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

FROM centos:7.8.2003

ENV ftp_proxy=$ftp_proxy
ENV http_proxy=$http_proxy
ENV https_proxy=$https_proxy
ENV no_proxy=$no_proxy

RUN yum update -y
RUN yum install -y iperf3 net-tools tcpdump ethtool iproute traceroute

WORKDIR /root/

COPY ./iperf_client.sh ./

CMD ["./iperf_client.sh"]
