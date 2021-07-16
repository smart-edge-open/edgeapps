#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2021 Exium Inc.
script_dir="$(dirname "$0")"
AUTH_FILE=${script_dir}/lib/service-account-xe.yaml
PARAM_FILE=${script_dir}/lib/exium-config.sh
echo  "$AUTH_FILE"
echo "$PARAM_FILE"
if [[ ! -f "$AUTH_FILE" ||  ! -f "$PARAM_FILE" ]]; then
    echo "All required files are not present."
    echo "Please contact Exium support: Email : support@exium.net" 
    exit 1
else
    echo "Dependency Validated.."	
fi
