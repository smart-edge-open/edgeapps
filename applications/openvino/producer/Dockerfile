# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2019 Intel Corporation

FROM ubuntu:16.04

ENV http_proxy=$http_proxy
ENV https_proxy=$https_proxy
ENV no_proxy=$no_proxy,eaa.openness

ENV GOPATH=/root/go
ENV GOROOT=/usr/local/go
ENV PATH=$PATH:$GOPATH/bin:$GOROOT/bin

# Type of acceleration to be used in OpenVINO inference:
# CPU | MYRIAD | HDDL | CPU_HDDL | CPU_MYRIAD
ENV OPENVINO_ACCL=CPU

RUN mkdir $GOPATH
# hadolint ignore=DL3008,DL3009,DL3015
RUN apt-get update && \
    apt-get -y install wget git && \
    rm -rf /var/lib/apt/lists/*

# Install Go
WORKDIR /tmp
RUN wget https://dl.google.com/go/go1.12.4.linux-amd64.tar.gz
RUN tar -xvf go1.12.4.linux-amd64.tar.gz
RUN mv go /usr/local
RUN rm -rf /tmp/go*

WORKDIR /root
COPY cmd/ ./

ENTRYPOINT ["go", "run", "main.go", "eaa_interface.go"]
