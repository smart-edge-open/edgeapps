# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2019 Intel Corporation

FROM centos:7.6.1810 AS builder

ENV http_proxy=$http_proxy
ENV https_proxy=$https_proxy
ENV DPDK_FILENAME=dpdk-19.11.tar.xz
ENV DPDK_LINK=https://fast.dpdk.org/rel/dpdk-19.11.tar.xz
ENV RTE_SDK=/root/dpdk-19.11/
ENV RTE_TARGET=x86_64-native-linuxapp-gcc
ENV BBDEV_PATCH=dpdk_19.11_new.patch

WORKDIR /root/
RUN yum install -y gcc-c++ make git xz-utils wget numactl-devel

COPY $BBDEV_PATCH .

RUN wget $DPDK_LINK
RUN tar -xf $DPDK_FILENAME 
RUN cd $RTE_SDK && cp ../$BBDEV_PATCH . &&  git apply $BBDEV_PATCH

# RT repo
RUN wget http://linuxsoft.cern.ch/cern/centos/7/rt/CentOS-RT.repo -O /etc/yum.repos.d/CentOS-RT.repo
RUN wget http://linuxsoft.cern.ch/cern/centos/7/os/x86_64/RPM-GPG-KEY-cern -O /etc/pki/rpm-gpg/RPM-GPG-KEY-cern

# install kernel sources to compile DPDK
RUN export isRT=$(uname -r | grep rt -c) && if [ $isRT = "1" ] ; then yum install -y "kernel-rt-devel-uname-r == $(uname -r)"; else yum install -y "kernel-devel-uname-r == $(uname -r)"; fi
RUN mkdir -p /lib/modules/$(uname -r)
RUN ln -s /usr/src/kernels/$(uname -r) /lib/modules/$(uname -r)/build

RUN cd $RTE_SDK && make install T=x86_64-native-linuxapp-gcc

RUN cd $RTE_SDK/app/test-bbdev && make

FROM centos:7.6.1810

ENV RTE_SDK=/root/dpdk-19.11/
ENV RTE_TARGET=x86_64-native-linuxapp-gcc

WORKDIR /root/
RUN yum install -y numactl-devel 
COPY --from=builder $RTE_SDK/app/test-bbdev/ .

