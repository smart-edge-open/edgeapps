# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2019 Intel Corporation

FROM ubuntu:18.04

ENV http_proxy=$http_proxy
ENV https_proxy=$https_proxy
ENV no_proxy=$no_proxy,eaa.openness,analytics.openness


##  OnPrem NTS uses CPU 0,2 and 3. 
##  So OpenVINO user needs to configure the value according the setup
ENV OPENVINO_TASKSET_CPU=8

ARG OPENVINO_LINK=https://registrationcenter-download.intel.com/akdlm/irc_nas/17504/l_openvino_toolkit_p_2021.2.185.tgz
#ARG OPENVINO_LINK=https://registrationcenter-download.intel.com/akdlm/irc_nas/17275/l_openvino_toolkit_fpga_p_2020.3.341.tgz
ARG YEAR=2021
ARG MODEL1_LINK=https://download.01.org/opencv/2019/open_model_zoo/R1/models_bin_20190329_105530/pedestrian-detection-adas-0002/
ARG MODEL2_LINK=https://download.01.org/opencv/2019/open_model_zoo/R1/models_bin_20190329_105530/vehicle-detection-adas-0002/

ARG OPENVINO_DEMOS_DIR=/opt/intel/openvino_$YEAR/deployment_tools/open_model_zoo/demos

RUN apt-get update && \
	apt-get -y install build-essential gcc g++ cmake && \
	apt-get -y install cpio && \
	apt-get -y install sudo && \
	apt-get -y install unzip && \
	apt-get -y install wget && \
	apt-get -y install lsb-core && \
	apt-get -y install autoconf libtool && \
	apt-get -y install ffmpeg x264 && \
	apt-get -y install git && \
	apt-get -y install util-linux && \
	apt-get -y install libusb-1.0-0-dev libudev-dev libssl-dev libboost-program-options1.65-dev libboost-thread1.65 libboost-filesystem1.65

ENV DEBIAN_FRONTEND=noninteractive
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
RUN echo "source /opt/intel/openvino_$YEAR/bin/setupvars.sh" >> ~/.bashrc
RUN bash -c "source ~/.bashrc"

# Build OpenVINO samples
RUN /bin/bash -c "source /opt/intel/openvino_$YEAR/bin/setupvars.sh \
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

# Install Go
RUN cd /tmp && \
	wget https://dl.google.com/go/go1.15.linux-amd64.tar.gz && \
	tar -xvf go1.15.linux-amd64.tar.gz && \
	mv go /usr/local && \
	rm -rf /tmp/go*

ENV GOPATH=/root/go
ENV GOROOT=/usr/local/go
ENV GO111MODULE=on
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH
RUN mkdir $GOPATH

# Work Dir
WORKDIR /root

# Get go dependencies
RUN git config --global http.proxy $http_proxy
RUN git config --global https.proxy $https_proxy
RUN go get github.com/gorilla/websocket
COPY cmd/ ./
RUN go build main.go openvino.go eaa_interface.go

# OpenVINO inference and forwarding
RUN mkfifo vidfifo.mjpeg
COPY start.sh ./
COPY fwd.sh ./

ENTRYPOINT ["./start.sh"]
