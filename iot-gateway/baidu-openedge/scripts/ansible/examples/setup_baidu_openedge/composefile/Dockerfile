# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2019 Intel Corporation

FROM ubuntu:18.04

ENV http_proxy=$http_proxy
ENV https_proxy=$https_proxy
ENV no_proxy=$no_proxy

ENV PATH /usr/local/go/bin:$PATH
RUN apt-get update 
RUN apt-get install -y python3.6
RUN apt-get install -y python3-pip
RUN apt-get install -y build-essential
RUN apt-get install -y vim

# needed by openedge when build
RUN apt-get install -y zip unzip tcpdump 
RUN pip3 install grpcio protobuf pyyaml

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo 'Asia/Shanghai' >/etc/timezone

#RUN yum install -y wget python iputils-ping python-pip openssh-server expect iperf3 net-tools openssh-clients psmisc
RUN apt-get install -y wget iputils-ping openssh-server expect iperf3 net-tools openssh-client psmisc
RUN apt-get install -y make 
RUN apt-get install -y git

WORKDIR /root/

# install python pip and grpcio
#RUN pip install protobuf grpcio

# install golang 
RUN wget https://dl.google.com/go/go1.11.4.linux-amd64.tar.gz
RUN tar -C /usr/local -zxf go1.11.4.linux-amd64.tar.gz
RUN export GOPATH=/usr/local/go
RUN export PATH=$GOPATH/bin:$PATH
RUN export GOROOT=/usr/local/go  
RUN export GOPATH=$PATH:$GOROOT/bin 
#RUN source ~/.bashrc


# download openedge and build it
RUN git clone https://github.com/baetyl/baetyl
RUN mkdir -p /usr/local/go/src/github.com/baidu/
RUN mv baetyl /usr/local/go/src/github.com/baidu/openedge
WORKDIR /usr/local/go/src/github.com/baidu/openedge
RUN git checkout tags/0.1.3
RUN make all
RUN make install-native


#
#COPY ./democfg/application.yml /usr/local/var/db/openedge/application.yml
#COPY ./democfg/agent-conf/service.yml /usr/local/var/db/openedge/agent-conf/service.yml
#COPY ./democfg/agent-cert/*.* /usr/local/var/db/openedge/agent-cert/
#COPY ./democfg/remote-iothub-conf/service.yml /usr/local/var/db/openedge/remote-iothub-conf/service.yml
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
