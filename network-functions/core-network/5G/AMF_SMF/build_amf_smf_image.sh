#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

if [[ ${#} -ne 2 ]]; then
    echo "Wrong arguments pased. Usage: ${0} <ubuntu_image_dest_dir> <astri_dir>"
    exit 1
fi

img_file=${1}/ubuntu-18.04-minimal-cloudimg-amd64.qcow2
astri_dir=${2}

if [[ ! -f ${img_file} ]]; then
    curl https://cloud-images.ubuntu.com/minimal/releases/bionic/release/ubuntu-18.04-minimal-cloudimg-amd64.img -o "${img_file}"
    if [[ ${?} -ne 0 ]]; then
        echo "ERROR: Failed to download Ubuntu image."
        exit 1
    fi
else
    echo "Skipping image download - file already exists."
fi

virt-customize -a "${img_file}" \
    --root-password password:root \
    --update \
    --install qemu-guest-agent,iputils-ping,iproute2,screen,libpcap-dev,tcpdump,libsctp-dev,apache2,python-pip,sudo,ssh \
    --mkdir /root/amf-smf \
    --copy-in "${astri_dir}:/root/amf-smf"

if [[ ${?} -ne 0 ]]; then
    echo "ERROR: Failed to customize the image."
    exit 1
fi
