```text
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2020 Intel Corporation
```

# Introduction

4G/LTE or 5G User Plane Functions (UPF) can run as network functions on Edge node in a virtualized environment.  The reference  `Dockerfile` and `5g-upf.yaml` files could help to bring-up the UPF functions in docker container on OpenNESS edge node using OpenNESS Enhanced Platform Awareness (EPA) features.  

These scripts are validated through a reference UPF solution (implementation based Vector Packet Processing (VPP)), is not part of OpenNESS release. 


# How to build

To keep the build and deploy process simple for reference, docker build and image are stored on the Edge node itself.  

```code
ne-node02# cd <5g-upf-binary-package>

#
# Copy Dockerfile and 5g-upf.yaml files 
#

ne-node02# docker build --build-arg http_proxy=$http_proxy --build-arg https_proxy=$https_proxy --build-arg no_proxy=$no_proxy -t 5g-upf:1.0 .

```

# UPF configure 

To keep the bring-up setup simple and to the point, UPF configuration was made static through config files placed inside the UPF binary package.  However one can think of ConfigMaps and/or Secrets services in Kubernetes to provide configuration information to UPF workloads.  

Below are the list of minimal configuration parameters that one can think of for a VPP based applications like UPF, 

## Platform specific information:

- SR-IOV PCIe interface(s) bus address
- CPU core dedicated for UPF workloads
- Amount of Huge pages 

## UPF application specific information:
- N3, N4, N6 and N9 Interface IP addresses 

# How to start 

## Deploy UPF POD from OpenNESS controller

```code
ne-controller# kubectl create -f 5g-upf.yaml 
```

## To start UPF

In this reference validation, UPF application will be started manually after UPF POD deployed successfully. 

```code
ne-controller# kubectl exec -it test1-app -- /bin/bash

5g-upf# cd /root/upf
5g-upf# ./start_upf.sh
```
