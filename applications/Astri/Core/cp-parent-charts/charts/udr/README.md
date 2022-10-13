```
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2022 Astri Corporation
```


## Overview
This manual describes how to install udr using Helm chart and also illustrates the corresponding configurations.

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
 * RedisDb >= v4.0.9


## Installation

1. Load UDR image from tar file:
```
docker load -i UDR-image-v22.03-rc0.tar.gz
```

2. Install the UDR Helm Chart:

    Control Plane NFS Helm chart is located at **charts/cp-parent-charts/charts/**

    ```
    cd charts/cp-parent-charts/charts/

    helm install udr udr/
    ```
    Expected Output:

        NAME: udr
        LAST DEPLOYED: Wed Jul 28 22:02:55 2021
        NAMESPACE: default
        STATUS: deployed
        REVISION: 1
        TEST SUITE: None


## Uninstallation
```
helm uninstall udr
```
Expected Output:

    release "udr" uninstalled

## Configuration

| Parameter                          | Description                                            | Default                                          |
|------------------------------------|--------------------------------------------------------|--------------------------------------------------|
| `enabled`                          | Parameters to define if udr should be installed        | `true`
| `replicaCount`                     | Numbers of container to be deployed                    | `1`
| `image.repository`                 | Docker image name                                      | `astri.org/5g/udr`
| `image.tag`                        | Docker image tag for udr                               | `v22.03-rc0`
| `image.pullPolicy`                 | The Kubernetes imagePullPolicy value                   | `IfNotPresent`
| `tolerations`                      | Node tolerations for server scheduling to nodes with taints  | `[]`
| `podIP`                            | podIP is used to configure the IP address of Pod's calico network interface | `10.245.216.111`
| `networkConfigurations`            | Network Configurations for udr                         | `[]`
| `networkConfigurations.sbi`        | 5G SBI Network Configurations for udr                  | `[]`
| `networkConfigurations.sbi`        | 5G SBI Network Configurations for udr                  | `[]`
| `networkConfigurations.sbi.scheme` | Transport protocol scheme (http/https)                 | `http`
| `networkConfigurations.sbi.registerIPv4` | IP used to register to NRF                       | `127.0.0.4`
| `networkConfigurations.sbi.bindingIPv4` | Local IP used to bind the service                 | `10.245.216.111`
| `networkConfigurations.sbi.port`   | Local port used to bind the service                    | `80`
| `networkConfigurations.redisdb.url`| URL of RedisDB                                         | `"127.0.0.1:6379"`
| `networkConfigurations.nrfUri`     |  a valid URI of NRF                                    | `http://127.0.0.10:8000`
| `networkConfigurations.instanceid` | instance id of NRF                                     | `http://127.0.0.10:8000`
| `service`                          | udr Kubernetes service configurations                  | `[]`
| `service.annotations`              | udr service annotation                                 | `[]`
| `service.clusterIP`                | Cluster internal IP of udr Service                     | `[]`
| `service.externalIPs`              | List of IP addresses that udr service exposed          | `[]`
| `service.name`                     | Name of the Kubernetes service                         | `nudr`
| `service.type`                     | Configuration of UDR service types. Choosing this value makes the Service only reachable from within the cluster.        | `ClusterIP`
| `service.servicePort`              | Service port for UDR and UDM                           | `8866`
| `resources.limits.cpu`             | Number of CPU core limited                             | `250m`
| `resources.limits.memory`          | Memory limited in mebibyte                             | `256Mi`
| `resources.requests.cpu`           | Number of CPU core requested                           | `250m`
| `resources.requests.memory`        | Memory requested in mebibyte                           | `256Mi`
| `terminationGracePeriodSeconds`    | Pod's grace period of termination                      | `30`
| `licenseSecret`                    | License secret name                                    | `license-controller`


## Contact

Please contact ASTRI for sales information.
