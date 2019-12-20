# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2019 Intel Corporation

FROM centos:7.6.1810 AS builder

ENV http_proxy=$http_proxy
ENV https_proxy=$https_proxy
ENV DPDK_FILENAME=dpdk-18.08.tar.xz
ENV DPDK_LINK=https://fast.dpdk.org/rel/dpdk-18.08.tar.xz
ENV RTE_SDK=/root/dpdk-18.08/
ENV RTE_TARGET=x86_64-native-linuxapp-gcc
ENV BBDEV_PATCH=flexran-dpdk-bbdev-v19-10.patch

WORKDIR /root/
RUN yum install -y gcc-c++ make git xz-utils wget numactl-devel

COPY $BBDEV_PATCH .

RUN wget $DPDK_LINK
RUN tar -xf $DPDK_FILENAME 
RUN cd $RTE_SDK && cp ../$BBDEV_PATCH . &&  git apply $BBDEV_PATCH

# install kernel sources to compile DPDK
RUN yum install -y http://linuxsoft.cern.ch/centos-vault/7.6.1810/os/x86_64/Packages/kernel-devel-3.10.0-957.el7.x86_64.rpm
RUN mkdir -p /lib/modules/$(uname -r)
RUN ln -s /usr/src/kernels/$(uname -r) /lib/modules/$(uname -r)/build

RUN cd $RTE_SDK && make install T=x86_64-native-linuxapp-gcc

RUN cd $RTE_SDK/app/test-bbdev && make

FROM centos:7.6.1810

ENV RTE_SDK=/root/dpdk-18.08/
ENV RTE_TARGET=x86_64-native-linuxapp-gcc

WORKDIR /root/
RUN yum install -y numactl-devel 
COPY --from=builder $RTE_SDK/app/test-bbdev/ .

