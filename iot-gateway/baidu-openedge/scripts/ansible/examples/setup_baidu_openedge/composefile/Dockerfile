# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2019 Intel Corporation

FROM centos:7.6.1810

ENV PATH /usr/local/go/bin:$PATH
RUN yum install -y epel-release
RUN yum -y update 
RUN yum install -y python36
RUN yum install -y python36-pip python3-devel gcc-c++

# needed by openedge when build
RUN yum install -y zip unzip tcpdump 
RUN pip3 install grpcio protobuf pyyaml


#RUN yum install -y wget python iputils-ping python-pip openssh-server expect iperf3 net-tools openssh-clients psmisc
RUN yum install -y wget iputils-ping openssh-server expect iperf3 net-tools openssh-clients psmisc
RUN yum install -y make git

WORKDIR /root/

# install python pip and grpcio
#RUN pip install protobuf grpcio

# install golang 
RUN wget https://dl.google.com/go/go1.11.4.linux-amd64.tar.gz
RUN tar -C /usr/local -zxf go1.11.4.linux-amd64.tar.gz

# download openedge and build it
RUN git clone https://github.com/baetyl/baetyl
RUN mkdir -p /root/go/src/github.com/baidu/
RUN mv baetyl /root/go/src/github.com/baidu/openedge
WORKDIR /root/go/src/github.com/baidu/openedge
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
