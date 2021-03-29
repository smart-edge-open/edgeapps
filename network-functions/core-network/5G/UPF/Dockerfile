# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

FROM ubuntu:18.04

ENV http_proxy=$http_proxy
ENV https_proxy=$https_proxy
ENV no_proxy=$no_proxy
ARG binaries_path

RUN apt-get update && \
    apt-get -y install iputils-ping ethtool && \
    apt-get -y install python-pip libcap-ng-dev gawk pciutils kmod && \
    apt-get -y install libc6 pciutils python3 lsb-base libnuma-dev iproute2 findutils apt-utils  libtool fakeroot libmbedtls-dev libhyperscan4 sudo
RUN groupadd vpp

WORKDIR /root

COPY $binaries_path ./upf
COPY run_upf.sh ./run_upf.sh
# update with the location of the upf source
#COPY 5g_upf_vpp ./5g_upf_vpp
