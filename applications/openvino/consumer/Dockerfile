# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2019 Intel Corporation

FROM ubuntu:16.04

ENV http_proxy=$http_proxy
ENV https_proxy=$https_proxy
ENV no_proxy=$no_proxy,eaa.openness,analytics.openness

ENV GOPATH=/root/go
ENV GOROOT=/usr/local/go
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH

##  OnPrem NTS uses CPU 0,2 and 3. 
##  So OpenVINO user needs to configure the value according the setup
ENV OPENVINO_TASKSET_CPU=8

ARG OPENVINO_LINK=http://registrationcenter-download.intel.com/akdlm/irc_nas/15791/l_openvino_toolkit_fpga_p_2019.2.275.tgz
ARG MODEL1_LINK=https://download.01.org/opencv/2019/open_model_zoo/R1/models_bin_20190329_105530/pedestrian-detection-adas-0002/
ARG MODEL2_LINK=https://download.01.org/opencv/2019/open_model_zoo/R1/models_bin_20190329_105530/vehicle-detection-adas-0002/
ARG INSTALL_DIR=/tmp/openvino_installer
ARG OPENVINO_DEMOS_DIR=/opt/intel/openvino/deployment_tools/open_model_zoo/demos

RUN mkdir $GOPATH
RUN apt-get update && \
	apt-get -y install build-essential gcc g++ cmake && \
	apt-get -y install cpio && \
	apt-get -y install sudo && \
	apt-get -y install unzip && \
	apt-get -y install wget && \
	apt-get -y install lsb-core && \
	apt-get -y install autoconf libtool && \
	apt-get -y install ffmpeg libav-tools x264 && \
	apt-get -y install git && \
	apt-get -y install util-linux && \
	apt-get -y install libusb-1.0-0-dev libudev-dev libssl-dev libboost-program-options1.58-dev libboost-thread1.58 libboost-filesystem1.58

# OpenVino installation
RUN cd /tmp && \
	wget $OPENVINO_LINK && \
	tar xf l_openvino_toolkit*.tgz && \
	pwd && ls && \
	cd l_openvino_toolkit* && \
	sed -i 's/decline/accept/g' silent.cfg && \
	./install_openvino_dependencies.sh && \
	./install.sh -s silent.cfg && \
	rm -rf /tmp/l_openvino_toolkit*

WORKDIR /root
RUN echo "source /opt/intel/openvino/bin/setupvars.sh" >> ~/.bashrc

# Patch OpenVINO sample app
COPY object_detection_demo_ssd_async.patch $OPENVINO_DEMOS_DIR/object_detection_demo_ssd_async/
RUN patch $OPENVINO_DEMOS_DIR/object_detection_demo_ssd_async/main.cpp \
	$OPENVINO_DEMOS_DIR/object_detection_demo_ssd_async/object_detection_demo_ssd_async.patch

# Build OpenVINO samples
RUN /bin/bash -c "source /opt/intel/openvino/bin/setupvars.sh \
	&& $OPENVINO_DEMOS_DIR/build_demos.sh"

# Download OpenVINO pre-trained models
RUN wget -r -np -nH --cut-dirs=5 -R index.html* $MODEL1_LINK
RUN wget -r -np -nH --cut-dirs=5 -R index.html* $MODEL2_LINK

# Rebuilding libusb without UDEV support -- required for Intel Movidius Stick
RUN cd /tmp && \
	wget https://github.com/libusb/libusb/archive/v1.0.22.zip && \
	unzip v1.0.22.zip && cd libusb-1.0.22 && \
	./bootstrap.sh && \
	./configure --disable-udev --enable-shared && \
	make -j4 && make install && \
	rm -rf /tmp/*1.0.22*

# Install UDEV rules for Intel Movidius Stick
RUN /bin/bash -c "source /opt/intel/openvino/bin/setupvars.sh \
	&& /opt/intel/openvino/install_dependencies/install_NCS_udev_rules.sh"

# Install Go
RUN cd /tmp && \
	wget https://dl.google.com/go/go1.12.4.linux-amd64.tar.gz && \
	tar -xvf go1.12.4.linux-amd64.tar.gz && \
	mv go /usr/local && \
	rm -rf /tmp/go*

# Get go dependencies
RUN go get github.com/gorilla/websocket

# OpenVINO inference and forwarding
RUN mkfifo vidfifo.mjpeg
COPY start.sh ./
COPY fwd.sh ./
COPY cmd/ ./

ENTRYPOINT ["./start.sh"]
