#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

usage() { echo "Usage: $0 [-c <Path to the pfd configuration file>] [-p <Path to the sm policy config file>] [-s <local_dn subnet>] [-i <routed app id>]" 1>&2; exit 1; }

while getopts ":c:p:s:i:" o; do
    case "${o}" in
        c)
            c=${OPTARG}
            ;;
        p)
            p=${OPTARG}
            ;;
        s)
            s=${OPTARG}
            ;;
        i)
            i=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${c}" ] || [ -z "${p}" ] || [ -z "${s}" ]|| [ -z "${p}" ]; then
    usage
fi

sed -i "s/INTF=.*/INTF=net1/g" ./cp_config.sh

python update_amf_smf_configs.py \
  --pfd-config-file "$c" \
  --sm-policy-data-file "$p" \
  --local-dn-subnet "$s" \
  --app-id "$i";

./cp_config.sh
sleep 10
./cp_restart.sh

