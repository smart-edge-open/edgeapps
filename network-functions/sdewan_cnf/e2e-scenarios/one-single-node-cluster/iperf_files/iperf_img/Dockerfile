# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

FROM alpine:3.12.0

ENV ftp_proxy=$ftp_proxy
ENV http_proxy=$http_proxy
ENV https_proxy=$https_proxy
ENV no_proxy=$no_proxy

RUN apk update && apk add --no-cache bash iperf3 net-tools ethtool iproute2 tcptraceroute tcpdump

RUN addgroup -S iperfgroup && adduser -S client -G iperfgroup
RUN echo '%iperfgroup ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

COPY ./iperf_client.sh /iperf_client.sh
RUN  chmod +x /iperf_client.sh

USER client
WORKDIR /home/client

CMD ["sudo" "/iperf_client.sh"]
