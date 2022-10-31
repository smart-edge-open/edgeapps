# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation


FROM ubuntu:20.04

ENV http_proxy=$http_proxy
ENV https_proxy=$https_proxy
ENV no_proxy=$no_proxy
ENV DEBIAN_FRONTEND=noninteractive

ARG OPENVINO_LINK=https://registrationcenter-download.intel.com/akdlm/irc_nas/17062/l_openvino_toolkit_p_2021.1.110.tgz
ARG YEAR=2021
ARG INSTALL_DIR=/opt/intel/openvino_$YEAR
ARG TEMP_DIR=/tmp/openvino_installer

# hadolint ignore=DL3003,DL3008,DL3009
RUN apt-get update && apt-get install -y --no-install-recommends \
    cpio \
    sudo \
    wget \
    python3-pip \
    python3-setuptools \
    libboost-filesystem1.71 \
    libboost-thread1.71 \
    libboost-program-options1.71 \
    lsb-release \
    libjson-c-dev \
    build-essential \
    virtualenv \
    cmake \
    libcairo2-dev \
    libpango1.0-dev \
    libglib2.0-dev \
    libgtk2.0-dev \
    libswscale-dev \
    libavcodec-dev \
    libavformat-dev \
    libgstreamer1.0-0 \
    gstreamer1.0-plugins-base \
    libpng-dev


WORKDIR $TEMP_DIR
RUN wget $OPENVINO_LINK && \
        tar xf l_openvino_toolkit*.tgz && \
        cd l_openvino_toolkit* && \
        sed -i 's/decline/accept/g' silent.cfg && \
        ./install_openvino_dependencies.sh && \
        ./install.sh -s silent.cfg && \
        rm -rf /tmp/l_openvino_toolkit* && \
        ln --symbolic /opt/intel/openvino_"$YEAR"/ /opt/intel/openvino

RUN pip3 install --no-cache-dir networkx==2.3
WORKDIR /opt/intel/openvino_$YEAR/deployment_tools/demo
RUN /bin/bash -c "source $INSTALL_DIR/bin/setupvars.sh && ./demo_squeezenet_download_convert_run.sh"
WORKDIR /root/inference_engine_samples_build
RUN /bin/bash -c "source $INSTALL_DIR/bin/setupvars.sh && make"

# Creating user openvino and adding it to groups "video" and "users" to use GPU and VPU
RUN useradd -ms /bin/bash -G video,users openvino && \
    chown -R openvino /home/openvino
RUN mv /root/inference_engine_samples_build /home/openvino/
RUN mv /root/openvino_models /home/openvino/

RUN chown -R openvino:openvino $INSTALL_DIR/
RUN chown -R openvino:openvino /home/openvino/
USER openvino

#Download OpenVINO pre-trained models

WORKDIR /opt/intel/openvino_$YEAR/deployment_tools/open_model_zoo/tools/downloader
RUN pip3 install --no-cache-dir pyyaml requests
RUN ./downloader.py  --name face-detection-retail-0004
RUN ./downloader.py  --name squeezenet1.1
RUN ./downloader.py  --name semantic-segmentation-adas-0001
RUN ./downloader.py  --name ssd300
RUN ./downloader.py  --name ssd512
RUN /bin/bash -c "source $INSTALL_DIR/bin/setupvars.sh && ./converter.py --name ssd300"
RUN /bin/bash -c "source $INSTALL_DIR/bin/setupvars.sh && ./converter.py --name ssd512"

RUN chown -R openvino:openvino /home/openvino/

# build Inference Engine samples
RUN mkdir $INSTALL_DIR/deployment_tools/inference_engine/samples/cpp/build
WORKDIR $INSTALL_DIR/deployment_tools/inference_engine/samples/cpp/build
RUN /bin/bash -c "source $INSTALL_DIR/bin/setupvars.sh && cmake .. && make -j1"

WORKDIR /home/openvino
COPY do_benchmark.sh /home/openvino
