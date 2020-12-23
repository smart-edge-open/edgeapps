#! /bin/bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

echo "Pre-Installation setup for SDEWAN crd-controller"

LINK="https://github.com/jetstack/cert-manager/releases/download/v0.11.0/cert-manager.yaml"

function apply_cert_manager {
    kubectl apply -f $LINK --validate=false
}

# apply cert manager for crd-controlelr
apply_cert_manager
