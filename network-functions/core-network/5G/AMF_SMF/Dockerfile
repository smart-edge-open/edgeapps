# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

FROM ubuntu:18.04

ENV http_proxy=$http_proxy
ENV https_proxy=$https_proxy
ENV no_proxy=$no_proxy

RUN apt-get update && \
    apt-get install -y kmod iputils-ping vim iproute2 screen && \
    apt-get install -y tcpdump ethtool net-tools fakeroot libsctp-dev lksctp-tools sudo


WORKDIR /root

