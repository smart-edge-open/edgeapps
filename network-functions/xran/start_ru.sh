#! /bin/bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

ulimit -c unlimited
echo 1 > /proc/sys/kernel/core_uses_pid


./run_test.sh 

