#!/usr/bin/env bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2019 Intel Corporation

source ../../common/scripts/ansible-precheck.sh
source ../../common/vars/task_log_file.sh
ansible-playbook ./tasks/setup_main.yml -i ../../common/vars/hosts --connection=local
