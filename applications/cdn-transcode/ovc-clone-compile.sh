#! /bin/bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

echo "Cloning the CDN transcode sample"
git clone https://github.com/OpenVisualCloud/CDN-Transcode-Sample || { echo "git clone failed"; exit 2; }
cd CDN-Transcode-Sample
sed -i "s/^hosts=.*/hosts=(\$(kubectl get node -l vcac-zone!=yes -o custom-columns=NAME:metadata.name,STATUS:status.conditions[-1].type,TAINT:spec.taints | grep \" Ready \" | grep -v \"NoSchedule\" | cut -f1 -d' '))/" deployment/kubernetes/build.sh
mkdir -p build
cd build
mName=$(kubectl get nodes | grep master | cut -f 1 -d ' ')
mIP=$(kubectl get node -o 'custom-columns=NAME:.status.addresses[?(@.type=="Hostname")].address,IP:.status.addresses[?(@.type=="InternalIP")].address' | awk '!/NAME/{print $1":"$2}' | grep $mName | cut -f 2 -d':')
echo "mName=$mName mIP=$mIP"

cmake -DREGISTRY="${mIP}:5000/" ..
make || { echo "failed to compile CDN transcode Sample"; exit 2;}
echo "Success: Compiled the CDN Transcode Sample"


