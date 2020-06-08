# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

FROM golang:1.12.7 

ENV GO111MODULE=on

ADD ./main.go /usr/src/main.go
WORKDIR /go

RUN go build /usr/src/main.go
