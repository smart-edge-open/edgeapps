#!/bin/bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

LINK=$(readlink -f "$0")
DIR=$(dirname "$LINK")

# delete pvs and scs
for yaml in "${DIR}"/CDN-Transcode-Sample/deployment/kubernetes/*-pv.yaml; do
    kubectl delete --wait=false -f "$yaml" --ignore-not-found=true 2>/dev/null
done

kubectl delete secret self-signed-certificate 2> /dev/null || echo -n ""

