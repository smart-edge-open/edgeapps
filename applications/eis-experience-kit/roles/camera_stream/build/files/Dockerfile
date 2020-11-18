# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation
FROM alpine:3.12.0
RUN apk add vlc
RUN adduser -D vlcuser
COPY streamstart.sh /tmp/
RUN chmod +x /tmp/streamstart.sh
COPY pcb_d2000.avi /tmp/
COPY Safety_Full_Hat_and_Vest.avi /tmp/
