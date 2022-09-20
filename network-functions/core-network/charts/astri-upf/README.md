
```text
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2021 Astri Corporation
```

**Overview**

ASTRI’s User Plane Function (UPF) can be distributed and deployed close to the users to enable ultra-low latency and time-sensitive usage scenarios in 5G network.

ASTRI’s UPF delivers high network throughput with low packet latency. ASTRI’s UPF can leverage the Dynamic Device Personalization (DDP) capability on Intel XXV710 to achieve fine grade load balancing.

**Prerequisites**

The UPF and UPF agent container require at least 4 CPU core, 8Gi memory for optimized performance. There should be 1024Mb hugepage memory on the host system.

Pre-deploy container images for ASTRI’s UPF on upf node:

* upf-v20.12-rc5.tar.gz
* upf-agent-v20.12-rc1.tar.gz

UPF and UPF agent image could be loaded into docker image by using following commands:

```
docker load -i upf-v20.12-rc5.tar.gz
docker load -i upf-agent-v20.12-rc1.tar.gz
```

The helm charts of UPF and UPF agent should be also copied to the controller for deployment. 

**Usage**

Install the UPF and UPF agent chart

UPF and UPF agent chart is located in the upf folder.

```
helm install upf upf/
```

**Test Output**

```
NAME: upf
LAST DEPLOYED: Fri Mar 19 15:13:46 2021
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
```

**Uninstall Chart**

```
helm delete  upf
```

**Test Output**

```
release "upf" uninstalled
```
Additional Information

Learn more about ASTRI UPF at https://www.astri.org/IMPACT/smart-city/revolutionary-5g-core-performance.html

**Where to Buy**

Please contact ASTRI for sales information.
