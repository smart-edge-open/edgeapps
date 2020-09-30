#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2019-2020 Intel Corporation

BASE_PATH="$( cd "$(dirname "$0")" ; pwd -P )"

[ -d "${BASE_PATH}/logs" ] || mkdir  "${BASE_PATH}/logs"
FILENAME="$(date +%Y-%m-%d_%H-%M-%S_ansible.log)"

# Comment out below export to disable console logs saving to files.
export ANSIBLE_LOG_PATH="${BASE_PATH}/logs/${FILENAME}"
