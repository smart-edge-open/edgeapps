# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2019 Intel Corporation

FROM golang:1.13.15 as Builder

ENV http_proxy=$http_proxy
ENV https_proxy=$https_proxy
ENV no_proxy=$no_proxy,eaa.openness

ENV GO111MODULE=on
ENV PATH=$PATH:$GOPATH/bin:$GOROOT/bin

WORKDIR /root
COPY cmd/ ./
RUN go build main.go eaa_interface.go

FROM alpine:3.13
COPY --from=Builder /lib/x86_64-linux-gnu/libpthread.so.0 /lib/x86_64-linux-gnu/libpthread.so.0
COPY --from=Builder /lib/x86_64-linux-gnu/libc.so.6 /lib/x86_64-linux-gnu/libc.so.6
COPY --from=Builder /lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2

# Type of acceleration to be used in OpenVINO inference:
# CPU | MYRIAD | HDDL | CPU_HDDL | CPU_MYRIAD
ENV OPENVINO_ACCL=CPU

RUN adduser -S -D -H -u 100 -h /var/user -s /sbin/nologin -G users -g user user
COPY --from=Builder /root/main /var/user/main
WORKDIR /var/user
USER user

CMD ["./main"]
