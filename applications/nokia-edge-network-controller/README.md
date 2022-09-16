SPDX-License-Identifier: Apache-2.0

Copyright (c) 2022 Nokia Corporation

# Nokia Edge Network Controller

## Overview

The Nokia Edge Network Controller provides a cloud-native network automation function designed to address the unique needs of edge clouds. It enables your network engineering, architecture and operations teams to collaborate through a common NetOps approach and gives them a simple and flexible way to automate IP network design and configuration.  

Use the Kubernetes paradigm and API to make it easy for your applications to consume network resources in the edge cloud.  

Edge Network Controller version 22.6 was tested on Smart Edge Developer Experience Kit 21.12

## Edge Network Controller architecture 

Edge Network Controller consists of 3 components: the Network Intent Operator, Network Scaler Operator and the Network Scaler CNI Plugin. Depending on how you want to use Edge Network Controller, you need either to install only Network Intent Operator, or all 3 components. 

The Edge Network Controller Network Intent Operator and Edge Network Controller Network Scaler Operator can be installed via Helm charts and require the docker images to be available on the cluster. The Edge Network Controller Network Scaler CNI Plugin needs to be installed on each worker (the binary is needed on the workers). 



## Edge Network Controller Network Intent Operator 

Edge Network controller (ENC) Network Intent Operator — NwI Operator for short — is a Kubernetes operator for managing the configuration of Service Router Linux and Service Router Operating System network switches via the Kubernetes API. NwI Operator enables organizations that wish to use Kubernetes as a universal control plane to manage their data center resources to also manage their network switches. NwI Operator can be used to manage multiple SR OS and SR Linux switches, including multiple of both switch models at the same time. 

## Edge Network Controller Network Scaler Operator 

Edge Network controller (ENC) Network Scaler Operator — NwS Operator for short — is a Kubernetes operator that dynamically updates Service Router Linux and Service Router Operating System switches when a new Kubernetes workload (pod) is deployed. The WorkloadInterface Custom Resource Definition (CRD) that NwS Operator's controller watches and reacts to are created by the companion component, ENC Network Scaler CNI Plugin. NwS Operator and NwS CNI Plugin form the ENC Network Scaler solution.  

## Edge Network Controller Network Scaler CNI Plugin 

Edge Network Controller (ENC) Network Scaler CNI Plugin — NwS CNI Plugin for short — is a Container Network Interface (CNI) plugin that uses Link Layer Discovery Protocol (LLDP) to detect the network switch port that the Kubernetes workload (pod) is connected to. NwS CNI Plugin's companion component, ENC Network Scaler Operator, then dynamically updates the SR Linux or SR OS network switch to map the pod's VLAN to the correct switch port. NwS CNI Plugin and NwS Operator form the ENC Network Scaler solution.

## Install instructions
In the release bundles you find installation instructions in the *docs/* folder with each component.

## Obtaining the container images
Retrieve Container Images from: [Nokia Customer portal](https://customer.nokia.com/s/product2/01t3h000002naAXAAY/nsp-network-orchestration)

## Additional information
More about Edge Network Controller: [Edge Network Controller product info](https://www.nokia.com/networks/ip-networks/edge-network-controller/).
For more product inquiries, [connect with Nokia Sales](https://www.nokia.com/networks/connect-with-sales/) 




