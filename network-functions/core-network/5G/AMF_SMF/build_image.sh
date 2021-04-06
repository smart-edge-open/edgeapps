#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

usage() { echo "Usage: $0 [-b <Subdirectory which contains binary files for AMF-SMF>]" 1>&2; exit 1; }

while getopts "b:" o; do
    case "${o}" in
        b)
            b=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${b}" ]; then
    usage
fi

declare http_proxy https_proxy no_proxy
sudo docker build \
    --build-arg http_proxy="$http_proxy" \
    --build-arg https_proxy="$https_proxy" \
    --build-arg no_proxy="$no_proxy" \
    --build-arg binaries_path="$b" \
    -t amf-smf:1.0 .

