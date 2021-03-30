#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

# Get HDDL benchmark environment information and results.

JOB=openvino-benchmark-job


BENCHMARK_PATH=benchmark/openvino/hddl
mkdir -p ${BENCHMARK_PATH}

# CPU info
lscpu | tee ${BENCHMARK_PATH}/lscpu.info

# oek version
git log -n 1 | tee ${BENCHMARK_PATH}/oek.commit.head

# kernel version
uname -r | tee  ${BENCHMARK_PATH}/kernel.version

# proc information
cat /proc/cmdline > ${BENCHMARK_PATH}/kernel.cmdline
cat /proc/cpuinfo > ${BENCHMARK_PATH}/proc.cpuinfo
cat /proc/meminfo > ${BENCHMARK_PATH}/proc.meminfo

# HDDL information
lspci | grep USB | tee ${BENCHMARK_PATH}/HDDL_Card.info
yum install usbutils -y
lsusb | grep "Myriad VPU" | tee ${BENCHMARK_PATH}/HDDL_VPU.info
ls /dev/myriad* | tee ${BENCHMARK_PATH}/myriad_dev.info

# openvino version
OPENVINO_TOOLKIT=$(grep "ARG DOWNLOAD_LINK=" edgeapps/applications/openvino/benchmark/Dockerfile)
echo "${OPENVINO_TOOLKIT##*=}" > "${BENCHMARK_PATH}"/openvino.version

# benchmark results
kubectl get jobs $JOB
PODNAME=$(kubectl get pods -o name |grep $JOB)
kubectl logs "${PODNAME##*/}" -c $JOB > "${BENCHMARK_PATH}"/"$TARGET_DEVICE"_"$API"_"${IMAGE##*/}"_"${MODEL##*/}".log

echo "Enter ${BENCHMARK_PATH} to check benchmark environment information and results."
