# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation
#!/bin/bash

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
cat /proc/cmdline | tee  ${BENCHMARK_PATH}/kernel.cmdline
cat /proc/cpuinfo | tee  ${BENCHMARK_PATH}/proc.cpuinfo
cat /proc/meminfo  | tee  ${BENCHMARK_PATH}/proc.meminfo

# openvino version
OPENVINO_TOOLKIT=`grep "ARG DOWNLOAD_LINK=" edgeapps/applications/openvino/benchmark/Dockerfile`
echo ${OPENVINO_TOOLKIT##*=} > ${BENCHMARK_PATH}/openvino.version

# benchmark results
CONTAINER_BENCH=$JOB
kubectl get jobs $JOB
PODNAME=`kubectl get pods -o name |grep $JOB`
kubectl logs ${PODNAME##*/} -c $JOB > ${BENCHMARK_PATH}/$TARGET_DEVICE_$API_${IMAGE##*/}_${MODEL##*/}.log

echo "Enter ${BENCHMARK_PATH} to check benchmark environment information and results."
