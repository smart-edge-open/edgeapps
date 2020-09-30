#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

#Default path to Telemetry root CA on EdgeC Controller
CERT_PATH="/etc/openness/certs/telemetry/CA/cert.pem"

kubectl create secret generic root-cert --from-file=${CERT_PATH} --namespace=default
