#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

if [ -z "${FLEXRAN_DIR}" ] || [ -z "${DIR_WIRELESS_SDK}" ] || [ -z "${RTE_SDK}" ] \
   || [ -z "${ICC_DIR}" ] || [ -z "${DIR_WIRELESS_TEST_4G}" ] ; then
   echo "Not all required variables are set. Please set all of the variables"
   exit 1
fi

# Copy l1app and testmac binaries
cp -rf "${FLEXRAN_DIR}"/bin .

# Copy Wireless SDK
mkdir -p sdk
cp -rf "${DIR_WIRELESS_SDK}" sdk/

# Copy DPDK
cp -rf "${RTE_SDK}" dpdk-20.11

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
cp -rf "${DIR_WIRELESS_TEST_4G}"/fd tests/

# Copy WLS Module
cp -rf "${FLEXRAN_DIR}"/wls_mod .

DOCKER_BUILDKIT=1 docker build . --network host -t flexran4g:3.10.0-1160.11.1.rt56
