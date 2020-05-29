#!/bin/bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2019 Intel Corporation

DIR=$(dirname $(readlink -f "$0"))

kubectl delete secret self-signed-certificate 2> /dev/null || echo -n ""
kubectl delete configmap sensor-info 2> /dev/null || echo -n ""
