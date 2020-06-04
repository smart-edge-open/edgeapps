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
- [References](#references)

## Installing OpenNESS
The OpenNESS must be installed before going forward with Smart City application deployment. Installation is performed through [OpenNESS playbooks](https://github.com/otcshare/specs/blob/master/doc/getting-started/network-edge/controller-edge-node-setup.md).

> **NOTE:** At the time of writing this guide, there was no [Network Policy for Kubernetes](https://kubernetes.io/docs/concepts/services-networking/network-policies/) defined yet for the Smart City application. So, it is advised to remove the default OpenNESS network policies using this command:
> ```shell
> kubectl delete netpol block-all-ingress cdi-upload-proxy-policy
> ```

Details on deploying the application is provided in the following sections.

## Deploying the Smart City Application

This mode provide an easy and quick start with executing the application in the OpenNESS environment.

1. On the OpenNESS Controller node, clone the Smart City reference pipeline source code from [GitHub](https://github.com/OpenVisualCloud/Smart-City-Sample.git)

    ```shell
    git clone https://github.com/OpenVisualCloud/Smart-City-Sample.git
    cd Smart-City-Sample
    ```

2. Build the Smart City application

    ```shell
    mkdir build
    cd build
    cmake -DREGISTRY=<controller-node-ip>:5000 
    make
    ```

    > **NOTE:** OpenNESS Docker registry is deployed on the controller node. To push the Smart City docker images to the registry, the OpenNESS Controller node IP address should be substituted in the place of `<controller-node-ip>`.

1. Execute the `pre-install.sh` script to generate, self-sign and create certificates secret

    ```shell
    ./pre-install.sh
    ```

2. Install the application using the Helm chart

    ```shell
    helm install smart-city-app Smart-City-Sample/deployment/kubernetes/helm/smtc
    ```

3. From a web browser, launch the Smart City web UI at URL `https://<controller-node-ip>/`


## Deploying the Smart City Application with VCAC-A

Visual Cloud Accelerator Card - Analytics (VCAC-A) is a PCIe add on card comprising of Intel Core i3-7100U Processor with Intel HD Graphics 620 and 12 Movidius VPUs. Provisioning the network edge with VCAC-A acceleration through OpenNESS Experience Kits enables dense and performant Smart City video analytics and transcoding pipelines.

1. Enable VCAC-A playbook by placing the OpenNESS edge node hostname, that has the VCAC-A card(s) plugged-in, in `[edgenode_vca_group]` group in `inventory.ini` file of the openness-experience-kit.

2. Configure openness-experience-kit to deploy "Weave Net" CNI by editing `group_vars/all/10-default.yml`

    ```yaml
    kubernetes_cnis:
      - weavenet
    ```

    > **NOTE:** [Weave Net](https://www.weave.works/docs/net/latest/overview/) is currently the only supported CNI for VCAC-A.

3. Set the line `k8s_device_plugins_enable: true` in `group_vars/all/10-default.yml`

4. On the OpenNESS Controller node, clone the Smart City reference pipeline source code from [GitHub](https://github.com/OpenVisualCloud/Smart-City-Sample.git)

    ```shell
    git clone https://github.com/OpenVisualCloud/Smart-City-Sample.git
    cd Smart-City-Sample
    ```

5. Build the Smart City application with VCAC-A acceleration enabled

    ```shell
    mkdir build
    cd build
    cmake -DPLATFORM=VCAC-A -DREGISTRY=<controller-node-ip>:5000 ..
    make
    ```

    > **NOTE:** OpenNESS Docker registry is deployed on the controller node. To push the Smart City docker images to the registry, the OpenNESS Controller node IP address should be substituted in the place of `<controller-node-ip>`.

6. Execute the `pre-install.sh` script to generate, self-sign and create certificates secret

    ```shell
    ./pre-install.sh
    ```

7. Install the application using the Helm chart

    ```shell
    helm install smart-city-app Smart-City-Sample/deployment/kubernetes/helm/smtc
    ```

8.  From a web browser, launch the Smart City web UI at URL `https://<controller-node-ip>/`


## Un-Installing the Smart City Application

To uninstall the Smart City application, execute the following commands,

```shell
helm uninstall smart-city-app
./clean.sh
```

## References

- [OpenNESS Smart City application whitepaper](https://github.com/otcshare/specs/blob/master/doc/applications/openness_ovc.md)
- [Intel Open Visual Cloud Smart City reference pipeline](https://github.com/OpenVisualCloud/Smart-City-Sample)
- [Intel Open Visual Cloud VCAC-A card media analytics software](https://github.com/OpenVisualCloud/VCAC-SW-Analytics/)
