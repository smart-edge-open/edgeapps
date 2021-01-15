#! /bin/bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

TAG=v20.4

echo "Cloning the CDN transcode sample tag: $TAG"
git clone https://github.com/OpenVisualCloud/CDN-Transcode-Sample || { echo "git clone failed"; exit 2; }
cd CDN-Transcode-Sample || { echo "Dir does not exist"; exit 3; }
git checkout tags/v20.4 || { echo "Failed to checkout Tag $TAG"; exit 3; }
mkdir -p build
cd build || { echo "Dir does not exist"; exit 3; }

if kubectl get pods -A | grep harbor-registry ; then
	mName=$(kubectl get nodes | grep master | cut -f 1 -d ' ')
	if [ -n "$mName" ]; then
		mIP=$(kubectl get node -o 'custom-columns=NAME:.status.addresses[?(@.type=="Hostname")].address,IP:.status.addresses[?(@.type=="InternalIP")].address' | awk '!/NAME/{print $1":"$2}' | grep "$mName" | cut -f 2 -d':')
	fi
	echo "mName=$mName mIP=$mIP" 
fi

if [ -n "$mIP" ]; then
	cmake -DREGISTRY="${mIP}:30003/intel/" ..
else
	cmake ..
fi

make || { echo "failed to compile CDN transcode Sample"; exit 2;}
echo "Success: Compiled the CDN Transcode Sample"
