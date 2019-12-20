# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2019 Intel Corporation

FROM centos:7.6.1810

RUN yum install -y openssl \
    && yum clean all

WORKDIR /root/

COPY ./producer .

CMD ["./producer"]
