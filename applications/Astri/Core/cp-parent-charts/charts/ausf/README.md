```
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2022 Astri Corporation
```


## Overview
This manual describes how to install AUSF using Helm chart and also illustrates the corresponding configurations.

ASTRI 5G SA Characteristics
* 3GPP Release 15 compliance
* Can be evolved to comply 3GPP Release 16
* Service Base Architecture
* Support of Standalone (SA) 5G Network
* Suitable for vertical and enterprise market
* Suitable for edge deployment
* General purpose x86 platform hardware
* Roaming Not Supported


## Prerequisites

**1.Recommend Hardware Requirements for Control-Plane Network Functions Containers:**
 * 16 Core CPU
 * 32Gi Memory

**2.Software Requirements:**
 * Ubuntu 18.04
 * Kubernets >=v 1.17
 * Helm >= v3.1


## Installation

1. Load AUSF image from tar file:
```
docker load -i ausf-image-v22.03-rc0.tar.gz
```

2. Install the AUSF Helm Chart:

    Control Plane NFS Helm chart is located at **charts/cp-parent-charts/charts/**

    ```
    cd charts/cp-parent-charts/charts/

    helm install ausf ausf/
    ```
    Expected Output:

        NAME: ausf
        LAST DEPLOYED: Wed Jul 28 22:02:55 2021
        NAMESPACE: default
        STATUS: deployed
        REVISION: 1
        TEST SUITE: None


## Uninstallation
```
helm uninstall ausf
```
Expected Output:

    release "ausf" uninstalled

## Configuration

| Parameter                          | Description                                            | Default                                          |
|------------------------------------|--------------------------------------------------------|--------------------------------------------------|
| `enabled`                          | Parameters to define if AUSF should be installed       | `true`
| `replicaCount`                     | Numbers of container to be deployed                    | `1`
| `image.repository`                 | Docker image name                                      | `astri.org/5g/ausf`
| `image.tag`                        | Docker image tag for AUSF                              | `v22.03-rc0`
| `image.pullPolicy`                 | The Kubernetes imagePullPolicy value                   | `IfNotPresent`
| `podIP`                            | podIP is used to configure the IP address of Pod's calico network interface | `10.245.216.101`
| `networkInterfaces`                | 5G SBI Network Interfaces Configurations for AUSF       | `[]`
| `networkInterfaces.http2Server`    | Local HTTP Server Address                               | `10.245.216.101`
| `networkInterfaces.http2ServerPort`    | Local HTTP Server Port                              | `2133`
| `networkInterfaces.http2Client`    | Local HTTP Client Address                               | `10.245.216.101`
| `networkInterfaces.http2ClientPort`    | Local HTTP Clinet Port                              | `2132`
| `networkInterfaces.http2Udm`       | UDM IP Address                                          | `10.245.216.131`
| `networkInterfaces.http2UdmPort`   | UDM Port                                                | `3123`
| `tolerations`                      | Node tolerations for server scheduling to nodes with taints  | `[]`
| `nodeSelector`                     | AUSF Node selector for pod assignment                  | `controller`
| `service`                          | AUSF Kubernetes service configurations                 | `[]`
| `service.annotations`              | AUSF service annotation                                | `[]`
| `service.clusterIP`                | Cluster internal IP of AUSF Service                    | `[]`
| `service.externalIPs`              | List of IP addresses that AUSF service exposed         | `[]`
| `service.name`                     | Name of the Kubernetes service                         | `n12`
| `service.type`                     | Configuration of AUSF service types. Choosing this value makes the Service only reachable from within the cluster.                    | `ClusterIP`
| `service.servicePort`              | Service port for N12                                   | `2133`
| `resources.limits.cpu`             | Number of CPU core limited                             | `250m`
| `resources.limits.memory`          | Memory limited in mebibyte                             | `256Mi`
| `resources.requests.cpu`           | Number of CPU core requested                           | `250m`
| `resources.requests.memory`        | Memory requested in mebibyte                           | `256Mi`
| `terminationGracePeriodSeconds`    | Pod's grace period of termination                      | `30`
| `licenseSecret`                    | License secret name                                    | `license-controller`


## Contact

Please contact ASTRI for sales information.
