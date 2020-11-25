# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2019 Intel Corporation

FROM alpine:3.12.0

ENV http_proxy=$http_proxy
ENV https_proxy=http://cuiz2x:czy*1992intel@child-prc.intel.com:914
ENV no_proxy=$no_proxy

ENV PATH /usr/local/go/bin:$PATH
RUN apk update
RUN apk add --no-cache sudo 
RUN apk add --no-cache build-base
RUN apk add --no-cache bash 
RUN apk add --no-cache wget zlib-dev openssl-dev 

#install python3.6
RUN wget https://www.python.org/ftp/python/3.6.5/Python-3.6.5.tgz
RUN tar xvf Python-3.6.5.tgz
WORKDIR Python-3.6.5
RUN ./configure --enable-optimizations --with-ensurepip=install
RUN make -j 8
RUN make altinstall
WORKDIR /usr/local/bin
RUN ln -s python3.6 pythonpython

#install pip3
RUN apk add --no-cache grpc python3-dev
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python3.6 get-pip.py

# needed by openedge when build
RUN apk add --no-cache zip unzip tcpdump 
RUN pip3 install protobuf 

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo 'Asia/Shanghai' >/etc/timezone

#RUN yum install -y wget python iputils-ping python-pip openssh-server expect iperf3 net-tools openssh-clients psmisc
RUN apk add --no-cache dhclient openssh-server expect iperf3 net-tools openssh-client psmisc
RUN apk add --no-cache make 
RUN apk add --no-cache git
RUN apk add --no-cache musl-dev

#WORKDIR /root/

# install python pip and grpcio
#RUN pip install protobuf grpcio

# install golang 
RUN apk add --no-cache go bash
RUN wget -O go.tgz https://dl.google.com/go/go1.10.3.src.tar.gz
RUN tar -C /usr/local -xzf go.tgz
WORKDIR /usr/local/go/src/
RUN ./make.bash
RUN export PATH="/usr/local/go/bin:$PATH"  
RUN GOPATH=/opt/go/
RUN PATH=$PATH:$GOPATH/bin

# download openedge and build it
RUN git clone https://github.com/baetyl/baetyl
RUN mkdir -p /usr/local/go/src/github.com/baidu/
RUN mv baetyl /usr/local/go/src/github.com/baidu/openedge
WORKDIR /usr/local/go/src/github.com/baidu/openedge
RUN git checkout tags/0.1.3
RUN make all
RUN make install-native

RUN addgroup -S baiduiotgroup && adduser -S baiduiot -G baiduiotgroup
RUN echo '%baiduiotgroup ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

#COPY ./democfg/application.yml /usr/local/var/db/openedge/application.yml
#COPY ./democfg/agent-conf/service.yml /usr/local/var/db/openedge/agent-conf/service.yml
#COPY ./democfg/agent-cert/*.* /usr/local/var/db/openedge/agent-cert/
#COPY ./democfg/remote-iothub-conf/service.yml /usr/local/var/db/openedge/remote-iothub-conf/service.yml
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
USER baiduiot
WORKDIR /home/baiduiot
ENTRYPOINT ["sudo", "/entrypoint.sh"]
