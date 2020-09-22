#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

if [[ ${#} -ne 2 ]]; then
    echo "Wrong arguments passed. Usage: ${0} <ubuntu_image_full_path> <astri_dir>"
    exit 1
fi

img_file=${1}
astri_dir=${2}

if [[ ! -f ${img_file} ]]; then
    curl https://cloud-images.ubuntu.com/minimal/releases/bionic/release/ubuntu-18.04-minimal-cloudimg-amd64.img -o "${img_file}"
    if [[ ${?} -ne 0 ]]; then
        echo "ERROR: Failed to download Ubuntu image."
        exit 1
    fi

    # Check SHA256 if downloaded file is correct
    curl https://cloud-images.ubuntu.com/minimal/releases/bionic/release/SHA256SUMS -o SHA256SUMS
    if [[ ${?} -ne 0 ]]; then
        echo "ERROR: Failed to download SHA256SUMS file."
        exit 1
    fi
    grep -q "$(sha256sum "${img_file}" | awk '{ print $1 }')" SHA256SUMS
    if [[ ${?} -ne 0 ]]; then
        echo "ERROR: Invalid checksum of downloaded file."
        exit 1
    fi
else
    echo "Skipping image download - file already exists."
fi

qemu-img resize "${img_file}" +5G
if [[ ${?} -ne 0 ]]; then
    echo "ERROR: Failed to resize the image."
    exit 1
fi

virt-customize -a "${img_file}" \
    --root-password password:root \
    --run-command "sudo growpart /dev/sda 1" \
    --run-command "sudo resize2fs /dev/sda1" \
    --update \
    --install qemu-guest-agent,iputils-ping,iproute2,screen,libpcap-dev,tcpdump,libsctp-dev,apache2,python-pip,sudo,ssh \
    --mkdir /root/amf-smf \
    --copy-in "${astri_dir}:/root/amf-smf"

if [[ ${?} -ne 0 ]]; then
    echo "ERROR: Failed to customize the image."
    exit 1
fi
