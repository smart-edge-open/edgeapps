```text
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2020 Intel Corporation
```

<!-- omit in toc -->
# Smart City Application with OpenNESS

Smart City application is a sample application that is built on top of the OpenVINO & Open Visual Cloud software stacks for media processing and analytics. The application is deployed across multiple regional offices (OpenNESS edge nodes).

- [Installing OpenNESS](#installing-openness)
- [Deploying the Smart City Application](#deploying-the-smart-city-application)
- [Deploying the Smart City Application with VCAC-A](#deploying-the-smart-city-application-with-vcac-a)
- [Un-Installing the Smart City Application](#un-installing-the-smart-city-application)
- [Deploying the Smart City Application with EMCO](#deploying-the-smart-city-application-with-emco)
- [References](#references)

## Installing OpenNESS
The OpenNESS must be installed before going forward with Smart City application deployment. Installation is performed through [OpenNESS Deployment Flavors](https://github.com/smart-edge-open/specs/blob/master/doc/flavors.md).

> **NOTE:** At the time of writing this guide, there was no [Network Policy for Kubernetes](https://kubernetes.io/docs/concepts/services-networking/network-policies/) defined yet for the Smart City application. So, it is advised to remove **all** the network policies existing in the `default` namespace such as:
> ```shell
> kubectl delete netpol block-all-ingress
> ```

Details on deploying the application is provided in the following sections.

## Deploying the Smart City Application

This mode provide an easy and quick start with executing the application in the OpenNESS environment.

1. Initialize the git submodule that will clone the Smart City reference pipeline source code from [GitHub](https://github.com/OpenVisualCloud/Smart-City-Sample.git)

    ```shell
    git submodule update --init
    cd app
    ```

2. Build the Smart City application

    > **NOTE:** Install `cmake` and `m4` tools if not installed already
    >  ```shell
    >  yum install cmake m4 -y
    >  ```

    ```shell
    mkdir build
    cd build
    cmake -DREGISTRY=<controller-node-ip>:30003/intel/ .. 
    make
    ```

    > **NOTE:** OpenNESS Harobor registry is deployed on the controller node. To push the Smart City docker images to the registry, the OpenNESS Controller node IP address should be substituted in place of `<controller-node-ip>`.

3. Execute the `pre-install.sh` script to generate, self-sign and create certificates secret

    ```shell
    ./pre-install.sh
    ```

4. Install the application using the Helm chart

    ```shell
    helm install smart-city-app app/deployment/kubernetes/helm/smtc
    ```

5. From a web browser, launch the Smart City web UI at URL `https://<controller-node-ip>/`


## Deploying the Smart City Application with VCAC-A

Visual Cloud Accelerator Card - Analytics (VCAC-A) is a PCIe add on card comprising of Intel Core i3-7100U Processor with Intel HD Graphics 620 and 12 Movidius VPUs. Provisioning the network edge with VCAC-A acceleration through Converged Edge Experience Kits enables dense and performant Smart City video analytics and transcoding pipelines.

1. Deploy the OpenNESS [Media Analytics Flavor with VCAC-A](https://github.com/smart-edge-open/specs/blob/master/doc/flavors.md#media-analytics-flavor-with-vcac-a) and place the OpenNESS edge node hostname, that has the VCAC-A card(s) plugged-in, in `edgenode_vca_group:` group in `inventory.yml` file of the converged-edge-experience-kits.

2. Configure converged-edge-experience-kits to deploy "Weave Net" CNI by editing `group_vars/all/10-default.yml`

    ```yaml
    kubernetes_cnis:
      - weavenet
    ```

    > **NOTE:** [Weave Net](https://www.weave.works/docs/net/latest/overview/) is currently the only supported CNI for VCAC-A.

3. Set the line `k8s_device_plugins_enable: true` in `group_vars/all/10-default.yml`

4. Initialize the git submodule that will clone the Smart City reference pipeline source code from [GitHub](https://github.com/OpenVisualCloud/Smart-City-Sample.git)

    ```shell
    git submodule update --init
    cd app
    ```

5. Build the Smart City application with VCAC-A acceleration enabled

    ```shell
    mkdir build
    cd build
    cmake -DPLATFORM=VCAC-A -DREGISTRY=<controller-node-ip>:30003/intel ..
    make
    ```

    > **NOTE:** OpenNESS Harbor registry is deployed on the controller node. To push the Smart City docker images to the registry, the OpenNESS Controller node IP address should be substituted in place of `<controller-node-ip>`.

6. Execute the `pre-install.sh` script to generate, self-sign and create certificates secret

    ```shell
    ./pre-install.sh
    ```

7. Install the application using the Helm chart

    ```shell
    helm install smart-city-app app/deployment/kubernetes/helm/smtc
    ```

8.  From a web browser, launch the Smart City web UI at URL `https://<controller-node-ip>/`


## Un-Installing the Smart City Application

To uninstall the Smart City application, execute the following commands,

```shell
helm uninstall smart-city-app
./clean.sh
```

## Deploying the Smart City Application with EMCO
EMCO (Edge Multi-Cluster Orchestration) is a Geo-distributed application orchestrator for Kubernetes\*. The main objective of EMCO is automation of the deployment of applications and services across clusters. It acts as a central orchestrator that can manage edge services and network functions across geographically distributed edge clusters from different third parties. Finally, the resource orchestration within a cluster of nodes will leverage Kubernetes* and Helm charts.

For more details, refer to [OpenNESS EMCO whitepaper](https://github.com/smart-edge-open/specs/blob/master/doc/building-blocks/emco/openness-emco.md).


## References

- [OpenNESS Smart City application whitepaper](https://github.com/smart-edge-open/specs/blob/master/doc/applications/openness_ovc.md)
- [Intel Open Visual Cloud Smart City reference pipeline](https://github.com/OpenVisualCloud/Smart-City-Sample)
- [Intel Open Visual Cloud VCAC-A card media analytics software](https://github.com/OpenVisualCloud/VCAC-SW-Analytics/)
