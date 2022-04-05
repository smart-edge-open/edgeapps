```text
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2022 A5G Networks Inc.
```
# **Autonomous Mobile Edge Connect (AMEC)**
A5G Networks Inc. is a leader and innovator in autonomous mobile network infrastructure software. A5G Networks is pioneering secure and scalable 4G, 5G and Wi-Fi autonomous software to enable smart connectivity for distributed network of networks. 

AutonomousMobileEdgeConnect creates a 4G/5G/WiFi network fabric for private networks, smart cities, connected cars and public networks. The edge network is created autonomously across hybrid and multi-cloud for best service experience. It leverages Smart Edge Open toolkit. Such software provides desired security, low latency and high throughput for public and private network use cases.

## Prerequisites
The prerequisites for deploying the application are as follows:

* Intel Smart Edge Open (release 21.09)
* Intel IDO Converged Edge Experience Kits flavour
* Kubernetes v1.20.0 or greater
* Helm v3.1.2 or greater
* A kubernetes cluster of 3 nodes - 1 master and 2 workers.
* System requirements per node - 8 vCPUs, 32GB RAM, 100GB disk.
* MetalLB Loadbalancer

## Configuration
The application comes with a basic configuration baked into the helm chart. The specific configuration is dependent on the actual deployment network. A corresponding values.yaml file can be used to override the one that comes with the helm chart. The corresponding user-guide/support can be provided on request.

## Installation
AutonomousMobileEdgeConnect application can be deployed via the provided Helm chart. 

### Preinstall Steps
The following steps need to be performed before the helm chart can be deployed:
* Create Persistent Volume and Persistent Volume Claim for MongoDB used by MongoDB Service installed as part of application. 
* Create Persistent Volume and Storge Class to be used by ELK stack installed as part of application.

### Installing Helm Chart
```shell
helm install <helm-release-name> <helm-chart-location>
```

#### Test Output
```shell
Thank you for installing <helm-chart-location>.
Your release is named blu1 in namespace <helm-release-name>.

To learn more about the release, try:
$ helm status <helm-release-name>
$ helm get all <helm-release-name>
```

### Uninstalling Helm Chart
```shell
$ helm uninstall <helm-release-name>
```
#### Test Output
```shell
release "<helm-release-name>" uninstalled
```

## **Where to Purchase**
### Contact
https://a5gnet.com/contact/
