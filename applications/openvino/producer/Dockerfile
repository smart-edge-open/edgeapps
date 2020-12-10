# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2019 Intel Corporation

FROM alpine:3.12.0

ENV http_proxy=$http_proxy
ENV https_proxy=$https_proxy
ENV no_proxy=$no_proxy,eaa.openness

# Type of acceleration to be used in OpenVINO inference:
# CPU | MYRIAD | HDDL | CPU_HDDL | CPU_MYRIAD
ENV OPENVINO_ACCL=CPU

# hadolint ignore=DL3008,DL3009,DL3015
RUN apk update && apk upgrade && \
    apk add wget git && \
    rm -rf /var/lib/apt/lists/*

# Install Go
# install golang
RUN apk add --no-cache go bash
RUN wget -O go.tgz https://dl.google.com/go/go1.13.15.src.tar.gz
RUN tar -C /usr/local -xzf go.tgz
WORKDIR /usr/local/go/src/
RUN ./make.bash
ENV GOPATH=/root/go
ENV GOROOT=/usr/local/go
ENV GO111MODULE=on
ENV PATH=$PATH:$GOPATH/bin:$GOROOT/bin


WORKDIR /root
COPY cmd/ ./

ENTRYPOINT ["go", "run", "main.go", "eaa_interface.go"]
