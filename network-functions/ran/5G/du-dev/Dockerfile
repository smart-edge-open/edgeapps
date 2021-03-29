# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

FROM centos:7.9.2009

ENV ftp_proxy=$ftp_proxy
ENV http_proxy=$http_proxy
ENV https_proxy=$https_proxy
ENV no_proxy=$no_proxy

RUN yum update -y && yum install -y hugepages libhugetlbfs-utils numactl-devel

WORKDIR /root/flexran/docker

COPY bin ./bin
COPY dpdk-20.11 ./dpdk-20.11
COPY icc_libs ./icc_libs
COPY libs ./libs
COPY sdk ./sdk
COPY tests ./tests
COPY wls_mod ./wls_mod

ENV localPath=/root/flexran/docker
ENV flexranPath=$localPath
ENV RTE_SDK=$localPath/dpdk-20.11
ENV RTE_TARGET=x86_64-native-linuxapp-icc
ENV WIRELESS_SDK_TARGET_ISA=avx512
ENV RPE_DIR=${flexranPath}/libs/ferrybridge
ENV ROE_DIR=${flexranPath}/libs/roe
ENV XRAN_DIR=${localPath}/flexran_xran
ENV WIRELESS_SDK_TOOLCHAIN=icc
ENV DIR_WIRELESS_SDK_ROOT=${localPath}/sdk
ENV DIR_WIRELESS_TEST_5G=${localPath}/tests
ENV SDK_BUILD=build-${WIRELESS_SDK_TARGET_ISA}-icc
ENV DIR_WIRELESS_SDK=${DIR_WIRELESS_SDK_ROOT}/${SDK_BUILD}
ENV FLEXRAN_SDK=${DIR_WIRELESS_SDK}/install
ENV DIR_WIRELESS_TABLE_5G=${flexranPath}/bin/nr5g/gnb/l1/table
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$localPath/icc_libs

