#########################################################
# Copyright 2019 Intel Corporation. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#########################################################

FROM ubuntu:16.04

ENV http_proxy=$http_proxy
ENV https_proxy=$https_proxy
ENV no_proxy=$no_proxy,eaa.community.appliance.mec

ENV GOPATH=/root/go
ENV GOROOT=/usr/local/go
ENV PATH=$PATH:$GOPATH/bin:$GOROOT/bin

# Type of acceleration to be used in OpenVINO inference:
# CPU | VPU | HDDL
ENV OPENVINO_ACCL=CPU

RUN mkdir $GOPATH
RUN apt-get update && \
    apt-get -y install wget git

# Install Go
RUN cd /tmp
RUN wget https://dl.google.com/go/go1.12.4.linux-amd64.tar.gz
RUN tar -xvf go1.12.4.linux-amd64.tar.gz
RUN mv go /usr/local
RUN rm -rf /tmp/go*

WORKDIR /root
COPY cmd/ ./

ENTRYPOINT ["go", "run", "main.go", "eaa_interface.go"]
