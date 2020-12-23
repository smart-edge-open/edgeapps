# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2019 Intel Corporation

FROM alpine:3.12.0

RUN addgroup -S samplegroup && adduser -S sample -G samplegroup
USER sample
WORKDIR /home/sample

COPY ./consumer .

ENTRYPOINT ["./consumer"]
