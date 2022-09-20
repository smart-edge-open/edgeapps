# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2019 Intel Corporation

FROM ubuntu:20.04

ENV http_proxy=$http_proxy
ENV https_proxy=$https_proxy
ENV no_proxy=$no_proxy,openvino.openness
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /root

SHELL ["/bin/bash", "-xo", "pipefail", "-c"]

# hadolint ignore=DL3008
RUN apt-get update && \
       apt-get -y install build-essential gcc g++ cmake && \
       apt-get -y install cpio && \
       apt-get -y install sudo && \
       apt-get -y install unzip && \
       apt-get -y install wget && \
       apt-get -y install curl && \
       apt-get -y install lsb-core && \
       apt-get -y install autoconf libtool && \
       apt-get -y install ffmpeg x264 && \
       rm -rf /var/lib/apt/lists/*

RUN ln -snf /usr/share/zoneinfo/$(curl https://ipapi.co/timezone -k) /etc/localtime

RUN wget  --no-check-certificate https://storage.googleapis.com/coverr-main/zip/Rainy_Street.zip
RUN unzip Rainy_Street.zip

COPY tx_video.sh .
COPY start.sh .
ENTRYPOINT ["./start.sh"]
