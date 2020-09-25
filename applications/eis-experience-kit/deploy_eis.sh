#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

source scripts/ansible-precheck.sh  # check if ansibles are already installed
                                    # and ready to use
source scripts/task_log_file.sh

ansible-playbook -vv ./eis_sources.yml --inventory inventory.ini

source scripts/eis_repo_config.sh .

ansible-playbook -vv ./eis.yml --inventory inventory.ini
exit $?
