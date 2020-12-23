# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

FROM centos:7.8.2003

ENV ftp_proxy=$ftp_proxy
ENV https_proxy $https_proxy
ENV http_proxy $http_proxy
ENV no_proxy $no_proxy

ENV local_path /opt

WORKDIR $local_path

ENV XRAN_DIR $local_path/flexran_xran
ENV RTE_SDK $local_path/dpdk-19.11
ENV RTE_TARGET x86_64-native-linuxapp-icc
ENV GTEST_DIR $local_path/gtest/
ENV GTEST_ROOT $GTEST_DIR/googletest

RUN yum update -y && \
    yum install -y libhugetlbfs-utils libhugetlbfs numactl-devel pciutils chrony python

COPY dpdk-19.11 $RTE_SDK
COPY gtest $GTEST_DIR
COPY icc_libs ./icc_libs
COPY flexran_xran/app ./flexran_xran/app

WORKDIR $XRAN_DIR/app
COPY run_test.sh ./run_test.sh
COPY start_ru.sh ./start_ru.sh
COPY start_du.sh ./start_du.sh
COPY test_verification.py ./test_verification.py
RUN chmod 755 ./run_test.sh
RUN chmod 755 ./start_ru.sh
RUN chmod 755 ./start_du.sh
RUN chmod 755 ./test_verification.py

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$local_path/icc_libs/intel64
LABEL description="xRAN Fronthaul Sample Application"

