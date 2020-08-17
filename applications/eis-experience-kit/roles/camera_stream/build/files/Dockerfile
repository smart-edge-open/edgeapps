# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation
FROM centos:7
RUN yum install -y \
  epel-release \
  https://download1.rpmfusion.org/free/el/rpmfusion-free-release-7.noarch.rpm \
  && yum install -y vlc
RUN useradd -m vlcuser
COPY streamstart.sh /tmp/
RUN chmod +x /tmp/streamstart.sh
COPY pcb_d2000.avi /tmp/
COPY Safety_Full_Hat_and_Vest.mp4 /tmp/
