# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2019 Intel Corporation

FROM alpine:3.12.0

ENV http_proxy=$http_proxy
ENV https_proxy=$https_proxy
ENV no_proxy=$no_proxy,openvino.openness


WORKDIR /root

SHELL ["/bin/sh", "-xo", "pipefail", "-c"]


# hadolint ignore=DL3008
RUN apk update && apk upgrade  && \
       apk add build-base gcc g++ cmake && \
       apk add cpio && \
       apk add sudo && \
       apk add unzip && \
       apk add wget && \
       apk add autoconf libtool && \
       apk add ffmpeg x264 && \
       rm -rf /var/lib/apk/lists/*


RUN ln -snf /usr/share/zoneinfo/$(curl https://ipapi.co/timezone -k) /etc/localtime


RUN wget  --no-check-certificate https://storage.googleapis.com/coverr-main/zip/Rainy_Street.zip
RUN unzip Rainy_Street.zip


COPY downstream.sdp .
COPY tx_video.sh .
COPY start.sh .
ENTRYPOINT ["./start.sh"]
