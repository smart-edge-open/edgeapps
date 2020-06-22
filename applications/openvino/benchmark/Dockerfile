# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation


FROM ubuntu:18.04

ENV http_proxy=$http_proxy
ENV https_proxy=$https_proxy
ENV no_proxy=$no_proxy

ARG DOWNLOAD_LINK=http://registrationcenter-download.intel.com/akdlm/irc_nas/16612/l_openvino_toolkit_p_2020.2.120.tgz
ARG INSTALL_DIR=/opt/intel/openvino
ARG TEMP_DIR=/tmp/openvino_installer
# hadolint ignore=DL3020
ADD $DOWNLOAD_LINK $TEMP_DIR/openvino.tgz
# hadolint ignore=DL3003,DL3009
RUN apt-get update
# hadolint ignore=DL3003,DL3008
RUN apt-get install -y --no-install-recommends \
    cpio \
    sudo \
    python3-pip \
    python3-setuptools \
    libboost-filesystem1.65 \
    libboost-thread1.65 \
    libboost-program-options1.65 \
    lsb-release \
    libjson-c-dev
# hadolint ignore=DL3003
RUN cd $TEMP_DIR && \
    tar xf openvino.tgz && \
    cd l_openvino_toolkit* && \
    sed -i 's/decline/accept/g' silent.cfg && \
    ./install.sh -s silent.cfg && \
    rm -rf $TEMP_DIR

RUN $INSTALL_DIR/install_dependencies/install_openvino_dependencies.sh

# build Inference Engine samples
RUN mkdir $INSTALL_DIR/deployment_tools/inference_engine/samples/cpp/build 
WORKDIR $INSTALL_DIR/deployment_tools/inference_engine/samples/cpp/build
RUN /bin/bash -c "source $INSTALL_DIR/bin/setupvars.sh && cmake .. && make -j1"
RUN pip3 install networkx==2.3

WORKDIR /opt/intel/openvino/deployment_tools/demo
RUN /bin/bash -c "source $INSTALL_DIR/bin/setupvars.sh && ./demo_squeezenet_download_convert_run.sh"


WORKDIR /root/inference_engine_samples_build
RUN /bin/bash -c "source $INSTALL_DIR/bin/setupvars.sh && make"

COPY do_benchmark.sh /
