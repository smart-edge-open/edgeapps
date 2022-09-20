```
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2022 Astri Corporation
```


# Overview

ASTRI's User Plane Function (UPF) can be distributed and deployed close to the users to enable ultra-low latency and time-sensitive usage scenarios in 5G network.

ASTRI's UPF delivers high network throughput with low packet latency. ASTRI's UPF can leverage the Dynamic Device Personalization (DDP) capability on Intel XXV710 to achieve fine grade load balancing.

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

**1.Minimum Hardware Requirements for UPF & UPF-agent Container:**

 * 4 Cores CPU
 * 8Gi memory for optimized performance
 * 1024Mb Hugepage Memory on the host


**2. Prepare Container Images for ASTRI's UPF on UPF Node:**

* UPF-image-v22.03-rc0.tar.gz
* UPF-agent-image-v22.03-rc0.tar.gz


**3. Check if iommu is enable and hugepage size.**

```
cat /proc/cmdline
```
intel_iommu=on iommu=pt default_hugepagesz=2M hugepagesz=2M hugepages=1024


**4. Create VF related CRD resource.**

sriovnetworknodovnetwork.openshift.io
sriovnetworks.sriovnetwork.openshift.io


**5. The Helm Charts of UPF & UPF Agent Should be Copied to the Kubernetes Controller for Deployment.**

# Prerequisites - Installing OpenNESS

| Configuration      | Description |
| -----------        | ----------- |
| OpenNESS Version   | 22.01       |
| network_edge.yml   | Comment out 'import_playbook' of  Provision target infrastructure, Provision Kubernetes cluster, Applications    |
| edgenode_group.yml |   ptp_sync_enable: false      |
| edgenode_group.yml |   CPUs to be isolated:  isolcpus: "1-31,33-63,65-95,97-127"      CPUs not to be isolated: os_cpu_affinity_cpus: "0,32,64,96"     |


# Where to Purchase
Please contact liangdong@astri.org for User Plane Function images

ASTRI official website: https://www.astri.org/

# Installation

**1. Load upf/upf-agent image from tar files:**

```
docker load -i UPF-image-v22.03-rc0.tar.gz
docker load -i UPF-agent-image-v22.03-rc0.tar.gz
```

**2. Install the UPF and UPF agent chart:**

    UPF and UPF agent chart is located at the upf folder.
    ```
    cd charts/dp/
    helm install upf upf/
    ```
    Expected Output:

        NAME: upf
        LAST DEPLOYED: Wed Mar 23 17:22:54 2022
        NAMESPACE: default
        STATUS: deployed
        REVISION: 1
        TEST SUITE: None

# Uninstallation

```
helm delete upf
```
Expected Output:

    release "upf" uninstalled

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
docker tag astri.org/5g/upf:v22.03-rc0 172.18.31.116:30003/astri.org/5g/upf:v22.03-rc0
```


**3. Docker push the image into the Harbor registry:**

Example:
```
docker push 172.18.31.116:30003/astri.org/5g/upf:v22.03-rc0
```

# Configuration

| Parameter                          | Description                                                       | Default                                          |
|------------------------------------|-------------------------------------------------------------------|--------------------------------------------------|
| `replicaCount`                     | Numbers of container to be deployed                               | `1`
| `nodeSelector`                     | SMF Node selector for pod assignment                              | `kubernetes.io/hostname: node01`
| `vpp.image.repository`             | Docker image name                                                 | `astri.org/5g/upf`
| `vpp.image.tag`                    | Docker image tag for UPF                                          | `v22.03-rc0`
| `vpp.image.pullPolicy`             | The Kubernetes imagePullPolicy value                              | `IfNotPresent`
| `vpp.n3.sriovNetworkName`          | SriovNetworkName name for n3                                      | `sriov-n2n3`
| `vpp.n3.ipAddress`                 | IP address for n3                                                 | `192.168.28.176`
| `vpp.n3.mask`                      | Mask for n3 IP address                                            | `24`
| `vpp.n4.podIPAddr`                 | Parameters to define if calico CNI should be used                 | `true`
| `vpp.n4.vf.sriovNetworkName`       | SriovNetworkName name for n4                                      | `sriov-n4`
| `vpp.n4.vf.ipAddress`              | IP address for n4                                                 | `192.168.23.177`
| `vpp.n4.vf.mask`                   | Mask for n4 IP address                                            | `24`
| `vpp.n6.sriovNetworkName`          | SriovNetworkName name for n6                                      | `sriov-n6`
| `vpp.n6.ipAddress`                 | IP address for n6                                                 | `192.168.24.197`
| `vpp.n6.mask`                      | Mask for n6 IP address                                            | `24`
| `vpp.n6.gw`                        | Gateway for n6                                                    | `192.168.24.1`
| `vpp.edgeAppNetworks`              | Edge app IP address                                               | `10.96.0.10/32`
| `vpp.ueNetworks`                   | UE networks                                                       | `172.20.0.0/16, 172.21.0.0/16`
| `vpp.vethPeerHostAddress`          | Veth peer address for host                                        | `172.30.30.1/24`
| `vpp.vethPeerVppAddress`           | Veth peer address for vpp                                         | `172.30.30.30/24`
| `vpp.n6NatEnable`                  | Parameters to define if NAT function should be used               | `true`
| `vpp.dnsRedirectEnable`            | Parameters to define if DNS redirect function should be used      | `false`
| `vpp.dnsServerIP`                  | DNS server IP address                                             | `10.96.0.10`
| `vpp.licenseSecret`                | License secret name                                               | `license-node01`
| `vpp.resources.requests.cpu`       | Number of CPU core requested in vpp-c container                   | `4`
| `vpp.resources.requests.memory`    | Memory requested in mebibyte in vpp-c container                   | `6144Mi`
| `vpp.resources.limits.cpu`         | Number of CPU core limited in vpp-c container                     | `4`
| `vpp.resources.limits.memory`      | Memory limited in mebibyte in vpp-c container                     | `6144Mi`
| `vpp.resources.limits.hugepages-1Gi`     | Hugepage limited in vpp-c container                         | `4Gi`
| `vpp.SriovNetwork.ResouceName:number`  | Resource name and number for sriov network in vpp-c container | `intel.com/intel_sriov_UPF_IN: 1` `intel.com/intel_sriov_UPF_OUT: 1`
| `vpp.initresources.requests.cpu`       | Number of CPU core requested in init container                | `256m`
| `vpp.initresources.requests.memory`    | Memory requested in mebibyte in init container                | `256Mi`
| `vpp.initresources.limits.cpu`       | Number of CPU core limited in init container                    | `256m`
| `vpp.initresources.limits.memory`    | Memory limited in mebibyte in init container                    | `256Mi`
| `vppagent.image.repository`        | Docker image name                                                 | `astri.org/5g/upf-agent`
| `vppagent.image.tag`               | Docker image tag for UPF-agent                                    | `v22.03-rc0`
| `vppagent.image.pullPolicy`        | The Kubernetes imagePullPolicy value                              | `IfNotPresent`
| `vppagent.resources.requests.cpu`  | Number of CPU core requested in vpp-agent-c container             | `256m`
| `vppagent.resources.requests.memory` | Memory requested in mebibyte in vpp-agent-c container           | `256Mi`
| `vppagent.resources.limits.cpu`    | Number of CPU core limited in vpp-agent-c container               | `256m`
| `vppagent.resources.limits.memory` | Memory limited in mebibyte in vpp-agent-c container               | `256Mi`

# Contact

Please contact ASTRI for sales information.
Learn more about ASTRI UPF at https://www.astri.org/IMPACT/smart-city/revolutionary-5g-core-performance.html
