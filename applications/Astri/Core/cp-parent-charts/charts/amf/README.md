```
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2022 Astri Corporation
```


## Overview
This manual describes how to install AMF using Helm chart and also illustrates the corresponding configurations.

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

1. Load AMF image from tar file:
```
docker load -i amf-image-v22.03-rc0.tar.gz
```

2. Install the AMF Helm Chart:

    Control Plane NFS Helm chart is located at **charts/cp-parent-charts/charts/**

    ```
    cd charts/cp-parent-charts/charts/

    helm install amf amf/
    ```
    Expected Output:

        NAME: amf
        LAST DEPLOYED: Wed Jul 28 22:02:55 2021
        NAMESPACE: default
        STATUS: deployed
        REVISION: 1
        TEST SUITE: None


## Uninstallation
```
helm uninstall amf
```
Expected Output:

    release "amf" uninstalled

## Configuration

| Parameter                          | Description                                            | Default                                          |
|------------------------------------|--------------------------------------------------------|--------------------------------------------------|
| `enabled`                          | Parameters to define if amf should be installed        | `true`
| `replicaCount`                     | Numbers of container to be deployed                    | `1`
| `image.repository`                 | Docker image name                                      | `astri.org/5g/amf`
| `image.tag`                        | Docker image tag for AMF                               | `v22.03-rc0`
| `image.pullPolicy`                 | The Kubernetes imagePullPolicy value                   | `IfNotPresent`
| `networks`                         | Kubernetes pod network resources configuration, set enabled: false to use default CNI option (e.g. calico, flannel)                     | `[]`
| `networks.enabled`                 | Parameters to define if  network resources should be used            | `false`
| `networks.name`                    | Name of the  network resource.                  | `[]`
| `tolerations`                      | Node tolerations for server scheduling to nodes with taints  | `[]`
| `podIP`                            | podIP is used to configure the IP address of Pod's calico network interface | `10.245.216.128`
| `networkInterfaces`                | 5G SBI Network Interfaces Configurations for AMF       | `[]`
| `networkInterfaces.ngapSctpServer` | Local SCTP Server Address                              | `10.245.216.128`
| `networkInterfaces.ngapSctpPort`   | Local SCTP Server Port                                 | `38412`
| `networkInterfaces.n11Http2Server` | Local N11 Interface Address                            | `10.245.216.128`
| `networkInterfaces.n11Http2ServerPort` | Local N11 Interface Port                           | `81`
| `networkInterfaces.n11Http2Client` | Local N11 Interface Client Address                     | `10.245.216.128`
| `networkInterfaces.n11Http2ClientPort` | Local N11 Interface Client Port                    | `8011`
| `networkInterfaces.n12Http2Client` | Local N12 Interface Client Address                     | `10.245.216.128`
| `networkInterfaces.n12Http2ClientPort` | Local N12 Interface Client Port                    | `8012`
| `networkInterfaces.n8Http2Server` | Local N8 Interface Address                              | `10.245.216.128`
| `networkInterfaces.n8Http2ServerPort` | Local N8 Interface Port                             | `88`
| `networkInterfaces.n8Http2Client` | Local N8 Interface Client Address                       | `10.245.216.128`
| `networkInterfaces.n8Http2ClientPort` | Local N8 Interface Client Port                      | `8008`
| `networkInterfaces.n15Http2Server` | Local N15 Interface Address                            | `10.245.216.128`
| `networkInterfaces.n15Http2ServerPort` | Local N15 Interface Port                           | `85`
| `networkInterfaces.n15Http2Client` | Local N15 Interface Client Address                     | `10.245.216.128`
| `networkInterfaces.n15Http2ClientPort` | Local N15 Interface Client Port                    | `8015`
| `networkInterfaces.nrfHttp2Server` | Local NRF Server Address                               | `192.168.120.29`
| `networkInterfaces.nrfHttp2ServerPort`   | Local NRF Server Port                            | `8016`
| `networkInterfaces.nrfHttp2Client` | Local NRF Client Address                               | `192.168.120.29`
| `networkInterfaces.nrfHttp2ClientPort`   | Local NRF Client Port                            | `8017`
| `nfProfiles`                       | nfProfiles defines local NF profiles for AMF without NRF integration  | `[]`
| `nfProfiles.ausfIP`                | AUSF IP Address                                        | `10.245.216.101`
| `nfProfiles.smfIP`                 | SMF IP Address                                         | `10.245.216.130`
| `nfProfiles.udmIP`                 | UDM IP Address                                         | `10.245.216.131`
| `nfProfiles.pcfIP`                 | PCF IP Address                                         | `10.245.216.129`
| `nodeSelector`                     | AMF Node selector for pod assignment                   | `controller`
| `service`                          | AMF Kubernetes service configurations                  | `[]`
| `service.annotations`              | AMF service annotation                                 | `{}`
| `service.clusterIP`                | Cluster internal IP of AMF Service                     | `[]`
| `service.externalIPs`              | List of IP addresses that AMF service exposed          | `[]`
| `service.name_n2`                  | Name for Kubernetes service of N2                      | `n2`
| `service.name_n11`                 | Name for Kubernetes service of N11                     | `n11`
| `service.name_n8`                  | Name for Kubernetes service of N8                      | `n8`
| `service.name_n15`                 | Name for Kubernetes service of N15                     | `n15`
| `service.type`                     | Configuration of AMF service types.Choosing this value makes the Service only reachable from within the cluster.     | `ClusterIP`
| `service.servicePort_n2`           | Service port for N2                                    | `38412`
| `service.servicePort_n11`          | Service port for N11                                   | `81`
| `service.servicePort_n8`           | Service port for N8                                    | `88`
| `service.servicePort_n15`          | Service port for N15                                   | `85`
| `resources.limits.cpu`             | Number of CPU core limited                             | `250m`
| `resources.limits.memory`          | Memory limited in mebibyte                             | `256Mi`
| `resources.requests.cpu`           | Number of CPU core requested                           | `250m`
| `resources.requests.memory`        | Memory requested in mebibyte                           | `256Mi`
| `terminationGracePeriodSeconds`    | Pod's grace period of termination                      | `30`
| `licenseSecret`                    | License secret name                                    | `license-controller`


## Contact

Please contact ASTRI for sales information.

