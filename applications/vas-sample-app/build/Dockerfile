# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

FROM centos:7.8.2003

ENV http_proxy=$http_proxy
ENV https_proxy=$https_proxy
ENV no_proxy=$no_proxy,eaa.openness,analytics-ffmpeg,analytics-gstreamer,media.openness

ENV GOPATH=/root/go
ENV GOROOT=/usr/local/go
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH

RUN yum install -y wget git

# Install Go
RUN cd /tmp && \
	wget https://dl.google.com/go/go1.15.linux-amd64.tar.gz && \
	tar -xvf go1.15.linux-amd64.tar.gz && \
	mv go /usr/local && \
	rm -rf /tmp/go*

WORKDIR /root

COPY build/start.sh ./
COPY cmd/ ./
ENTRYPOINT ["./start.sh"]
