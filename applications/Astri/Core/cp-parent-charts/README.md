```
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2022 Astri Corporation
```


## Overview

This manual describes how to install Controll Plane NFs(AMF, SMF, UDM, PCF, AUSF, UDR) using Helm chart and also illustrates the corresponding configurations.

ASTRI 5G SA Characteristics
* 3GPP Release 15 compliance
* Can be evolved to comply 3GPP Release 16
* Service Base Architecture
* Support of Standalone (SA) 5G Network
* Suitable for vertical and enterprise market
* Suitable for edge deployment
* General purpose x86 platform hardware
* Roaming Not Supported

# Prerequisites - Resource Required

**1.Recommend Hardware Requirements for Control-Plane Network Functions Containers:**

 * 16 Core CPU
 * 32Gi Memory


**2.Software Requirements for Control-Plane Network Functions**

 * Ubuntu 18.04
 * Kubernets >=v 1.17
 * Helm >= v3.1

# Prerequisites - Installing OpenNESS

| Configuration      | Description |
| -----------        | ----------- |
| OpenNESS Version   | 22.01       |
| network_edge.yml   | Comment out 'import_playbook' of  Provision target infrastructure, Provision Kubernetes cluster, Applications    |
| edgenode_group.yml |   ptp_sync_enable: false      |
| edgenode_group.yml |   CPUs to be isolated:  isolcpus: "1-31,33-63,65-95,97-127"      CPUs not to be isolated: os_cpu_affinity_cpus: "0,32,64,96"     |


# Where to Purchase
Please contact yolandatsang@astri.org for control plane network functions images

ASTRI official website: https://www.astri.org/

# Installation

**1. Load AMF, SMF, UDM, PCF, AUSF, UDR image from tar file:**

```
docker load -i AMF-image-v22.07-rc1.tar.gz
docker load -i SMF-image-v22.06-rc1.tar.gz
docker load -i UDM-image-v22.05-rc0.tar.gz
docker load -i PCF-image-v22.05-rc0.tar.gz
docker load -i AUSF-image-v22.05-rc0.tar.gz
docker load -i UDR-image-v22.03-rc0.tar.gz
```


**2. Install the Helm Chart:**

Control Plane NFs Helm chart is located at **charts/cp-parent-charts**

```
cd charts/

helm install cp cp-parent-charts/
```
Expected Output:

    NAME: cp
    LAST DEPLOYED: Wed Mar 23 10:04:07 2022
    NAMESPACE: default
    STATUS: deployed
    REVISION: 1
    TEST SUITE: None

# Uninstallation

```
helm uninstall cp
```
Expected Output:

    release "cp" uninstalled

# Testing if NFs Charts Have Been Sucessfully Installed
Check the running status of the pods
```
kubectl get pods -A
```


# Push Image into the Harbor Registry

**1. Docker login the Harbor registry:**

```
docker login <harbor_ip:port>
```
Example:
```
docker login 172.18.31.116:30003
Authenticating with existing credentials...
WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store
Login Succeeded
```


**2. Docker tag the image with Harbor IP and port:**

Example:
```
docker tag astri.org/5g/amf:v22.05-rc0 172.18.31.116:30003/astri.org/5g/amf:v22.05-rc0
```


**3. Docker push the image into the Harbor registry:**

Example:
```
docker push 172.18.31.116:30003/astri.org/5g/amf:v22.05-rc0
```

# Configuration

| Parameter                          | Description                                                    | Default                                          |
|------------------------------------|----------------------------------------------------------------|--------------------------------------------------|
| `global.upfN4IP`                   | If upf N4 is calico CNI, set ""                                | `192.168.23.177`
| `global.nodeSelector`              | Node selector for pod assignment                               | `kubernetes.io/hostname: controller`
| `global.licenseSecret`             | License secret name for NFs                                    | `license-controller`
| `amf.enabled`                      | Enable or disable the AMF deployment                           | `true`
| `amf.image.repository`             | Docker image name                                              | `astri.org/5g/amf`
| `amf.image.tag`                    | Docker image tag for AMF                                       | `v22.05-rc0`
| `amf.nodeSelector`                 | Node selector for pod assignment                               | `kubernetes.io/hostname: controller`
| `amf.licenseSecret`                | License secret name for AMF                                    | `license-controller`
| `ausf.enabled`                     | Enable or disable the AUSF deployment                          | `true`
| `ausf.image.repository`            | Docker image name                                              | `astri.org/5g/ausf`
| `ausf.image.tag`                   | Docker image tag for AUSF                                      | `v22.05-rc0`
| `ausf.nodeSelector`                | Node selector for pod assignment                               | `kubernetes.io/hostname: controller`
| `ausf.licenseSecret`               | License secret name for AUSF                                   | `license-controller`
| `pcf.enabled`                      | Enable or disable the PCF deployment                           | `true`
| `pcf.image.repository`             | Docker image name                                              | `astri.org/5g/pcf`
| `pcf.image.tag`                    | Docker image tag for PCF                                       | `v22.05-rc0`
| `pcf.dnsRedirectEnable`            | Parameters to define if dns redirect function should be used   | `false`
| `smf.enabled`                      | Enable or disable the SMF deployment                           | `true`
| `smf.image.repository`             | Docker image name                                              | `astri.org/5g/smf`
| `smf.image.tag`                    | Docker image tag for SMF                                       | `v22.06-rc1
| `udm.enabled`                      | Enable or disable the UDM deployment                           | `true`
| `udm.image.repository`             | Docker image name                                              | `astri.org/5g/udm`
| `udm.image.tag`                    | Docker image tag for UDM                                       | `v22.05-rc0`
| `udr.enabled`                      | Enable or disable the UDR deployment                           | `true`
| `udr.image.repository`             | Docker image name                                              | `astri.org/5g/udr`
| `udr.image.tag`                    | Docker image tag for UDR                                       | `v22.03-rc0`

# Contact

Please contact ASTRI for sales information.
