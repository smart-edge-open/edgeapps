# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2019 Intel Corporation

FROM centos:7.7.1908

ENV http_proxy=$http_proxy
ENV https_proxy=$https_proxy
ENV no_proxy=$no_proxy,openvino.openness

RUN yum install epel-release -y
RUN rpm -v --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro
RUN rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm
RUN yum install ffmpeg ffmpeg-devel wget unzip -y

WORKDIR /root
RUN wget https://storage.googleapis.com/coverr-main/zip/Rainy_Street.zip
RUN unzip Rainy_Street.zip
COPY downstream.sdp .
COPY tx_video.sh .
COPY start.sh .
ENTRYPOINT ["./start.sh"]
