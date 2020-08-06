#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

#Build docker image

echo "Building docker image"
docker build -t metricapp:0.1.0 .

args=("$@")

if [ "${args[0]}" == "push" ]
then
#tag docker image
    docker image tag metricapp:0.1.0 "${args[1]}:${args[2]}/intel/metricapp:0.1.0"
#push to docker registry
    docker push "${args[1]}:${args[2]}/intel/metricapp:0.1.0"
fi
