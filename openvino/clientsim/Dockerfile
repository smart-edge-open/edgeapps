# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2019 Intel Corporation

FROM ubuntu:16.04

ENV http_proxy=$http_proxy
ENV https_proxy=$https_proxy
ENV no_proxy=$no_proxy,openvino.openness

RUN apt-get update && \
    apt-get -y install ffmpeg wget unzip

WORKDIR /root
RUN wget https://storage.googleapis.com/coverr-main/zip/Rainy_Street.zip
RUN unzip Rainy_Street.zip
COPY downstream.sdp .
COPY tx_video.sh .
COPY start.sh .
ENTRYPOINT ["./start.sh"]
