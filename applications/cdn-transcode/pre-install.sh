#! /bin/bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

echo "Pre-Installation setup for CDN Transcode Sample"

LNK=$(readlink -f "$0")
DIR=$(dirname "$LNK")
function create_secret {
    kubectl create secret generic self-signed-certificate "--from-file=${DIR}/certs/self.crt" "--from-file=${DIR}/certs/self.key"
}

# create secrets
"$DIR/certs/self-sign.sh"
create_secret 2>/dev/null || (kubectl delete secret self-signed-certificate; create_secret)

for yaml in "$DIR"/CDN-Transcode-Sample/deployment/kubernetes/*-pv.yaml; do
    kubectl apply -f "$yaml"
done

# create volume
"$DIR/CDN-Transcode-Sample/deployment/kubernetes/mkvolume.sh"
