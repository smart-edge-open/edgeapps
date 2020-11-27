# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation
#!/bin/bash

# Get HDDL benchmark environment information and results.

JOB=openvino-benchmark-job

mkdir -p benchmark/openvino/hddl

# CPU info
lscpu | tee benchmark/openvino/hddl/lscpu.info

# oek version
git log -n 1 | tee benchmark/openvino/hddl/oek.commit.head

# kernel version
uname -r | tee  benchmark/openvino/hddl/kernel.version

# proc information
cat /proc/cmdline | tee  benchmark/openvino/hddl/kernel.cmdline
cat /proc/cpuinfo | tee  benchmark/openvino/hddl/proc.cpuinfo
cat /proc/meminfo  | tee  benchmark/openvino/hddl/proc.meminfo

# openvino version
OPENVINO_TOOLKIT=`grep "ARG DOWNLOAD_LINK=" edgeapps/applications/openvino/benchmark/Dockerfile`
echo ${OPENVINO_TOOLKIT##*=} > benchmark/openvino/hddl/openvino.version

# benchmark results
CONTAINER_BENCH=$JOB
kubectl get jobs $JOB
PODNAME=`kubectl get pods -o name |grep $JOB`
kubectl logs ${PODNAME##*/} -c $JOB > benchmark/openvino/hddl/$TARGET_DEVICE_$API_${IMAGE##*/}_${MODEL##*/}.log
