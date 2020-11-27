# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

FROM centos:7.8.2003

ENV ftp_proxy=$ftp_proxy
ENV http_proxy=$http_proxy
ENV https_proxy=$https_proxy
ENV no_proxy=$no_proxy

RUN yum update -y && yum install -y epel-release hugepages libhugetlbfs-utils numactl-devel openssl-devel make libatomic lksctp-tools-devel wget
RUN yum install -y python-pip \
    && pip install --upgrade pip \
    && pip install paramiko
RUN wget http://mirror.ghettoforge.org/distributions/gf/el/7/gf/x86_64/gcc10-libstdc++-10.2.1-7.gf.el7.x86_64.rpm \
    && wget http://mirror.ghettoforge.org/distributions/gf/el/7/gf/x86_64/gf-release-7-10.gf.el7.noarch.rpm
RUN rpm -Uvh gf-release*rpm
RUN yum --enablerepo=gf install -y gcc10-libstdc++

RUN yum update -y && yum install -y tcpdump iproute net-tools iputils pciutils lshw openssh-server openssh-clients vim

RUN rm -rf /usr/lib64/libstdc++.so.6 \
    && cp /opt/gcc-10.2.1/usr/lib64/libstdc++.so.6.0.28 /usr/lib64/ \
    && ln -s /usr/lib64/libstdc++.so.6.0.28 /usr/lib64/libstdc++.so.6

RUN ln -s /usr/lib64/libcrypto.so.1.0.2k /usr/lib64/libcrypto.so.1.0.0

WORKDIR /root/flexran/docker

COPY bin ./bin
COPY dpdk-19.11 ./dpdk-19.11
COPY icc_libs ./icc_libs
COPY libs ./libs
COPY sdk ./sdk
COPY tests ./tests
COPY wls_mod ./wls_mod

WORKDIR /root/rsys/docker

COPY DU ./DU
COPY CU ./CU

WORKDIR /root

COPY confd-basic-6.7 ./confd-basic-6.7

RUN cd confd-basic-6.7/; ./confd-basic-6.7.linux.x86_64.installer.bin confd-basic-6.7
RUN /bin/bash -c "source /root/confd-basic-6.7/confd-basic-6.7/confdrc \\
    && cd /root/rsys/docker/CU/liboam/oam_cu/confd/run/ \\
    && make clean; make all"
RUN /bin/bash -c "source /root/confd-basic-6.7/confd-basic-6.7/confdrc \\
    && cd /root/rsys/docker/DU/du_bin/liboam/oam_du/confd/run/ \\
    && make clean; make all"

ENV localPath=/root/flexran/docker
ENV flexranPath=$localPath
ENV RTE_SDK=$localPath/dpdk-19.11
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
ENV LD_LIBRARY_PATH=$localPath/icc_libs:$LD_LIBRARY_PATH

ENV rsysLocalPath=/root/rsys/docker/
ENV LD_LIBRARY_PATH=$rsysLocalPath/CU/liboam/oam_cu/confd/thirdparty:$rsysLocalPath/CU/liboam/oam_cu/lib/:$LD_LIBRARY_PATH
ENV LD_LIBRARY_PATH=$localPath/wls_mod/lib:$rsysLocalPath/DU/liboam/oam_du/lib/:$LD_LIBRARY_PATH
ENV LD_LIBRARY_PATH=/usr/local/lib64:/usr/local/lib:$LD_LIBRARY_PATH
ENV PATH=$PATH:/root/confd-basic-6.7/confd-basic-6.7/bin/
