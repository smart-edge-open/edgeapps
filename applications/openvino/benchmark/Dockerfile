# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation


FROM ubuntu:18.04

ENV http_proxy=$http_proxy
ENV https_proxy=$https_proxy
ENV no_proxy=$no_proxy

ARG DOWNLOAD_LINK=http://registrationcenter-download.intel.com/akdlm/irc_nas/16612/l_openvino_toolkit_p_2020.2.120.tgz
ARG INSTALL_DIR=/opt/intel/openvino
ARG TEMP_DIR=/tmp/openvino_installer

# hadolint ignore=DL3003,DL3008,DL3009
RUN apt-get update && apt-get install -y --no-install-recommends \
    cpio \
    sudo \
    wget \
    python3-pip \
    python3-setuptools \
    libboost-filesystem1.65 \
    libboost-thread1.65 \
    libboost-program-options1.65 \
    lsb-release \
    libjson-c-dev

WORKDIR $TEMP_DIR 
RUN wget $DOWNLOAD_LINK 
RUN tar xf l_openvino_toolkit*.tgz 

WORKDIR $TEMP_DIR/l_openvino_toolkit_p_2020.2.120
RUN sed -i 's/decline/accept/g' silent.cfg && \
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

#Download OpenVINO pre-trained models

RUN pip3 install pyyaml requests
WORKDIR /opt/intel/openvino/deployment_tools/open_model_zoo/tools/downloader
RUN ./downloader.py  --name face-detection-retail-0004
RUN ./downloader.py  --name squeezenet1.1
RUN ./downloader.py  --name semantic-segmentation-adas-0001
RUN ./downloader.py  --name ssd300
RUN ./downloader.py  --name ssd512
RUN /bin/bash -c "source $INSTALL_DIR/bin/setupvars.sh && ./converter.py --name ssd300"
RUN /bin/bash -c "source $INSTALL_DIR/bin/setupvars.sh && ./converter.py --name ssd512"

WORKDIR /root/inference_engine_samples_build
RUN /bin/bash -c "source $INSTALL_DIR/bin/setupvars.sh && make"

COPY do_benchmark.sh /
