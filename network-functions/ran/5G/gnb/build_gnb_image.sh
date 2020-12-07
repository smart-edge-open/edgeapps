#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

# Check if all variables are set
if [ -z "${FLEXRAN_DIR}" ] || [ -z "${DIR_WIRELESS_SDK}" ] || [ -z "${RTE_SDK}" ] \
   || [ -z "${ICC_DIR}" ] || [ -z "${DIR_WIRELESS_TEST_5G}" ] || [ -z "${CU_DU_DIR}" ] \
   || [ -z "${CONFD_DIR}" ]; then
   echo "Not all required variables are set. Please set all of the variables"
   exit 1
fi

# Copy l1app and testmac binaries
cp -rf "${FLEXRAN_DIR}"/bin .

# Copy Wireless SDK
mkdir -p sdk
cp -rf "${DIR_WIRELESS_SDK}" sdk/

# Copy DPDK
cp -rf "${RTE_SDK}" dpdk-19.11/

# Copy ICC libs
mkdir -p icc_libs
cp -f "${ICC_DIR}"/compilers_and_libraries_*/linux/compiler/lib/intel64/* icc_libs/
cp -f "${ICC_DIR}"/compilers_and_libraries/linux/ipp/lib/intel64/* icc_libs/
cp -f "${ICC_DIR}"/compilers_and_libraries/linux/mkl/lib/intel64/* icc_libs/

# Copy FlexRAN libs
mkdir -p libs
cp -rf "${FLEXRAN_DIR}"/libs/cpa libs/
cp -rf "${FLEXRAN_DIR}"/libs/cpa/sub6 libs/cpa_sub6

# Copy FD 5G tests
mkdir -p tests
cp -rf "${DIR_WIRELESS_TEST_5G}"/fd tests/

# Copy WLS Module
cp -rf "${FLEXRAN_DIR}"/wls_mod .

# Copy CU DU binaries
cp -rf "${CU_DU_DIR}"/CU .
cp -rf "${CU_DU_DIR}"/DU .

cp -rf "${CONFD_DIR}" confd-basic-6.7/

declare http_proxy https_proxy no_proxy ftp_proxy
sudo DOCKER_BUILDKIT=1 docker build \
   --build-arg http_proxy="$http_proxy" \
   --build-arg https_proxy="$https_proxy" \
   --build-arg no_proxy="$no_proxy" \
   --build-arg ftp_proxy="$ftp_proxy" \
   --network host \
   -t gnodeb5g:3.10.0-1127.19.1.rt56 .
