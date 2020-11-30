# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

FROM alpine:3.12.0

ENV ftp_proxy=$ftp_proxy
ENV http_proxy=$http_proxy
ENV https_proxy=$https_proxy
ENV no_proxy=$no_proxy

RUN apk update && apk add bash
RUN apk add --no-cache iperf3 net-tools ethtool iproute2 tcptraceroute tcpdump

WORKDIR /root/

COPY ./iperf_client.sh ./

CMD ["./iperf_client.sh"]
