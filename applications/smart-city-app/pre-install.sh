#!/bin/bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

DIR=$(dirname $(readlink -f "$0"))

function create_secret {
    kubectl create secret generic self-signed-certificate "--from-file=${DIR}/certs/self.crt" "--from-file=${DIR}/certs/self.key"
}

# create secrets
"$DIR/certs/self-sign.sh"
create_secret 2>/dev/null || (kubectl delete secret self-signed-certificate; create_secret)

# create configmap
kubectl create configmap sensor-info "--from-file=${DIR}/app/maintenance/db-init/sensor-info.json"
