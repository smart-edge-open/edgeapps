#!/bin/bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

DIR=$(dirname $(readlink -f "$0"))

# delete pvs and scs
for yaml in $(find "${DIR}/CDN-Transcode-Sample/deployment/kubernetes" -maxdepth 1 -name "*-pv.yaml" -print); do
    kubectl delete --wait=false -f "$yaml" --ignore-not-found=true 2>/dev/null
done

kubectl delete secret self-signed-certificate 2> /dev/null || echo -n ""

