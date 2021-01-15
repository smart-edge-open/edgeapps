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
ARG YEAR=2021
ARG OPENVINO_DEMOS_DIR=/opt/intel/openvino_$YEAR/deployment_tools/open_model_zoo/demos
ARG MODEL_ROOT=/opt/intel/openvino_$YEAR/deployment_tools/open_model_zoo/tools/downloader
ARG APP_DIR=/opt/intel/openvino_$YEAR/deployment_tools/inference_engine/demos/python_demos/object_detection_demo/

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
	apt-get -y install python3-pip && \
	apt-get -y install nginx libnginx-mod-rtmp libjson-c-dev && \
	apt-get -y install util-linux && \
	apt-get -y install libusb-1.0-0-dev libudev-dev libssl-dev libboost-program-options1.65-dev libboost-thread1.65 libboost-filesystem1.65

COPY nginx.conf /etc/nginx/nginx.conf
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
ADD object_detection_demo_ssd_async.patch $APP_DIR
RUN cd $APP_DIR && patch -p0 object_detection_demo.py object_detection_demo_ssd_async.patch

# Download OpenVINO pre-trained models
RUN cd $MODEL_ROOT && python3 -mpip install --user -r ./requirements.in && \
    ./downloader.py --name pedestrian-detection-adas-0002 && \
    ./downloader.py --name vehicle-detection-adas-0002

RUN cp -r $MODEL_ROOT/intel/vehicle-detection-adas-0002 $APP_DIR/ && \
    cp -r $MODEL_ROOT/intel/pedestrian-detection-adas-0002 $APP_DIR/

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

# Install numpy
RUN pip3 install numpy

ENV OPENVINO_ROOT=/opt/intel/openvino_$YEAR
ENV GOPATH=/root/go
ENV GOROOT=/usr/local/go
ENV GO111MODULE=on
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH
RUN mkdir $GOPATH

# Work Dir
WORKDIR /root

# Get go dependencies
RUN git config --global http.proxy $http_proxy
RUN go get github.com/gorilla/websocket
COPY cmd/ ./
ADD start.sh /root/
RUN go build main.go openvino.go eaa_interface.go
RUN rm -rf $GOPATH $GOROOT *.go go.*

# OpenVINO inference and forwarding
ENTRYPOINT ["./start.sh"]
