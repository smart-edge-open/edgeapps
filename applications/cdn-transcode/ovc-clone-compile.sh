#! /bin/bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

COMMIT=0e06f1004f7b7477d35882cf4dfce94ac86bf584

echo "Cloning the CDN transcode sample commit: $COMMIT"
git clone https://github.com/OpenVisualCloud/CDN-Transcode-Sample || { echo "git clone failed"; exit 2; }
cd CDN-Transcode-Sample
git reset --hard $COMMIT || { echo "Failed to reset to commit ID $COMMIT"; exit 3; }
mkdir -p build
cd build

if kubectl get pods -A | grep docker-registry ; then
	mName=$(kubectl get nodes | grep master | cut -f 1 -d ' ')
	if [ ! -z $mName ]; then
		mIP=$(kubectl get node -o 'custom-columns=NAME:.status.addresses[?(@.type=="Hostname")].address,IP:.status.addresses[?(@.type=="InternalIP")].address' | awk '!/NAME/{print $1":"$2}' | grep $mName | cut -f 2 -d':')
	fi
	echo "mName=$mName mIP=$mIP" 
fi

if [ ! -z $mIP ]; then
	cmake -DREGISTRY="${mIP}:5000/" ..
else
	cmake ..
fi

make || { echo "failed to compile CDN transcode Sample"; exit 2;}
echo "Success: Compiled the CDN Transcode Sample"


