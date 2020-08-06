#!/bin/bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

kubectl delete secret self-signed-certificate 2> /dev/null || echo -n ""
kubectl delete configmap sensor-info 2> /dev/null || echo -n ""
