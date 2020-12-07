# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

FROM golang:1.12.7-alpine as builder

ENV GO111MODULE=on

RUN apk update && apk add --no-cache git

COPY ./main.go /usr/src/main.go
WORKDIR /go

RUN go build /usr/src/main.go

FROM alpine:3.12
RUN apk add --no-cache bash
WORKDIR /go
COPY --from=builder /go/main ./
