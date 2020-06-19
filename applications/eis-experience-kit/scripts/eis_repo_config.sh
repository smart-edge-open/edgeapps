#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

if [ "$#" -ne 1 ]; then
    echo "Wrong argument count. Usage: $0 <path_to_eis_experience_kit_main_dir>"
    exit 1
fi

# get eis_sources_dir location from ./group_vars/all.yml
sources=$(cat $1/group_vars/all.yml | sed -n -e 's/^eis_sources_dir: //p' | sed 's@"@@g')

# combine two elements and get .env file location
env=$(cat $1/host_vars/localhost.yml | sed -n -e 's/^eis_env_file: //p' | sed  -e "s@{{ eis_sources_dir }}@$sources@" | sed 's@"@@g')

if [ ! -f "$env" ]; then
    echo "$env  doesn't exist. Terminating."
    exit 1
fi

set -a
source $env
set +a
