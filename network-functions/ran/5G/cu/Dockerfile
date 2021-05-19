# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

FROM centos:7.9.2009

ENV ftp_proxy=$ftp_proxy
ENV http_proxy=$http_proxy
ENV https_proxy=$https_proxy
ENV no_proxy=$no_proxy

RUN yum update -y && yum install -y epel-release hugepages libhugetlbfs-utils numactl-devel openssl-devel make libatomic lksctp-tools-devel wget sudo
RUN yum install -y python-pip \
    &&  pip install --upgrade pip==20.3.4 \
    && pip install paramiko

RUN wget http://mirror.ghettoforge.org/distributions/gf/el/7/gf/x86_64/gcc10-libstdc++-10.2.1-7.gf.el7.x86_64.rpm \
    && wget http://mirror.ghettoforge.org/distributions/gf/el/7/gf/x86_64/gf-release-7-10.gf.el7.noarch.rpm
RUN rpm -Uvh gf-release*rpm
RUN yum --enablerepo=gf install -y gcc10-libstdc++

RUN rm -rf /usr/lib64/libstdc++.so.6 \
    && cp /opt/gcc-10.2.1/usr/lib64/libstdc++.so.6.0.28 /usr/lib64/ \
    && ln -s /usr/lib64/libstdc++.so.6.0.28 /usr/lib64/libstdc++.so.6

RUN ln -s /usr/lib64/libcrypto.so.1.0.2k /usr/lib64/libcrypto.so.1.0.0

RUN yum update -y && yum install -y tcpdump iproute net-tools iputils pciutils lshw openssh-server openssh-clients vim

ARG gnodeb_path=/root/gnodeb/

WORKDIR ${gnodeb_path}

COPY dpdk-19.11 ./dpdk-19.11
COPY confd-basic-7.3 ./confd-basic-7.3
COPY cu_bin ./CU

ENV Cupath=${gnodeb_path}
ENV RTE_SDK=$localPath/dpdk-19.11
ENV LD_LIBRARY_PATH=$CuPath/CU/bin:$LD_LIBRARY_PATH
