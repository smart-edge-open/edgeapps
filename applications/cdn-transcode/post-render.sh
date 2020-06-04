#! /bin/bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

# post render script to use with helm
cat <&0 > all.yaml

./pre-install.sh &> ./logoutput

cat all.yaml && { rm -f all.yaml; rm  -f logoutput; }
