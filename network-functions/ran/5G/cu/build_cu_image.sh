#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

# Check if all variables are set
if [ -z "${RTE_SDK}" ] || [ -z "${CU_DIR}" ] || [ -z "${CONFD_DIR}" ]; then
   echo "Not all required variables are set. Please set all of the variables"
   exit 1
fi

# Copy DPDK
cp -rf "${RTE_SDK}" dpdk-19.11/

# Copy CU binary
cp -rf "${CU_DIR}" cu_bin/

# Copy confd directory
cp -rf "${CONFD_DIR}" confd-basic-7.3/

declare http_proxy https_proxy no_proxy ftp_proxy
sudo DOCKER_BUILDKIT=1 docker build \
   --build-arg http_proxy="$http_proxy" \
   --build-arg https_proxy="$https_proxy" \
   --build-arg no_proxy="$no_proxy" \
   --build-arg ftp_proxy="$ftp_proxy" \
   --network host \
   -t gnodebcu:3.10.0-1127.19.1.rt56 .
