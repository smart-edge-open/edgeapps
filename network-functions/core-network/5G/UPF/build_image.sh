#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

usage() { echo "Usage: $0 [-b <Subdirectory which contains binary files, e.g: i-upf or psa-upf>] [-i <Name of the image to be created: i-upf or psa-upf>]" 1>&2; exit 1; }

while getopts ":b:i:" o; do
    case "${o}" in
        b)
            b=${OPTARG}
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

if [ -z "${b}" ] || [ -z "${i}" ]; then
    usage
fi

declare http_proxy https_proxy no_proxy
sudo docker build \
    --build-arg http_proxy="$http_proxy" \
    --build-arg https_proxy="$https_proxy" \
    --build-arg no_proxy="$no_proxy" \
    --build-arg binaries_path="$b" \
    -t "$i":1.0 .

