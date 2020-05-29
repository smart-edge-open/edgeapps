```text
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2020 Intel Corporation
```

<!-- omit in toc -->
# Smart City Application with OpenNESS

Smart City application is a sample application that is built on top of the OpenVINO & Open Visual Cloud software stacks for media processing and analytics. The application is deployed across multiple regional offices (OpenNESS edge nodes).

- [Installing OpenNESS](#installing-openness)
- [Execution in Simulation Mode](#execution-in-simulation-mode)
- [Execution in Simulation Mode with VCAC-A](#execution-in-simulation-mode-with-vcac-a)
- [Execution within A Network Edge Context](#execution-within-a-network-edge-context)
  - [Configuring OpenNESS](#configuring-openness)
  - [Building Smart City ingredients](#building-smart-city-ingredients)
  - [Running Smart City](#running-smart-city)
- [References](#references)

## Installing OpenNESS
The OpenNESS must be installed before going forward with Smart City application deployment. Installation is performed through [OpenNESS playbooks](https://github.com/otcshare/specs/blob/master/doc/getting-started/network-edge/controller-edge-node-setup.md).

> **NOTE**: At the time of writing this guide, there was no [Network Policy for Kubernetes](https://kubernetes.io/docs/concepts/services-networking/network-policies/) defined yet for the Smart City application. So, it is advised to remove the default OpenNESS network policies using this command:
> ```shell
> kubectl delete netpol block-all-ingress cdi-upload-proxy-policy
> ```

The application can be executed in multiple modes:
1. In simulation mode
2. In simulation mode with VCAC-A
3. Within a network edge context

Details on executing each mode is provided in the following sections.

## Execution in Simulation Mode

This mode provide an easy and quick start with executing the application in the OpenNESS environment.

1. On the OpenNESS Controller machine, clone the Smart City reference pipeline source code from [GitHub](https://github.com/OpenVisualCloud/Smart-City-Sample.git)

    ```shell
    git clone https://github.com/OpenVisualCloud/Smart-City-Sample.git
    cd Smart-City-Sample
    ```

2. Build the Smart City application

    ```shell
    mkdir build
    cd build
    cmake ..
    make
    make update
    ```

3. Execute the `pre-install.sh` script to generate, self-sign and create certificates secret

    ```shell
    ./pre-install.sh
    ```

4. Install the application using the Helm chart

    ```shell
    helm install smart-city-app Smart-City-Sample/deployment/kubernetes/helm/smtc
    ```

5. From a web browser, launch the Smart City web UI at URL `https://<controller-node-ip>/`

6. To uninstall the application

    ```shell
    helm install smart-city-app
    ./clean.sh
    ```

## Execution in Simulation Mode with VCAC-A

Visual Cloud Accelerator Card - Analytics (VCAC-A) is a PCIe add on card comprising of Intel® Core™ i3-7100U Processor with Intel® HD Graphics 620 and 12 Movidius® VPUs. Provisioning the network edge with VCAC-A acceleration through OpenNESS Experience Kits enables dense and performant Smart City video analytics and transcoding pipelines.

1. Enable VCAC-A playbook by placing the OpenNESS edge node hostname, that has the VCAC-A card(s) plugged-in, in `[edgenode_vca_group]` group in `inventory.ini` file of the openness-experience-kit.

2. Configure openness-experience-kit to deploy "Weave Net" CNI by editing `group_vars/all.yml`

    ```yaml
    kubernetes_cnis:
    - weavenet
    ```

    > **NOTE**: [Weave Net](https://www.weave.works/docs/net/latest/overview/) is currently the only supported CNI for VCAC-A.

3. Set the line `k8s_device_plugins_enable: true` in `group_vars/all.yml`

4. On the OpenNESS Controller machine, clone the Smart City reference pipeline source code from [GitHub](https://github.com/OpenVisualCloud/Smart-City-Sample.git)

    ```shell
    git clone https://github.com/OpenVisualCloud/Smart-City-Sample.git
    cd Smart-City-Sample
    ```

5. Build the Smart City application with VCAC-A acceleration enabled

    ```shell
    mkdir build
    cd build
    cmake -DPLATFORM=VCAC-A ..
    make
    make update
    ```

6. Execute the `pre-install.sh` script to generate, self-sign and create certificates secret

    ```shell
    ./pre-install.sh
    ```

7. Install the application using the Helm chart

    ```shell
    helm install smart-city-app Smart-City-Sample/deployment/kubernetes/helm/smtc
    ```

8. From a web browser, launch the Smart City web UI at URL `https://<controller-node-ip>/`

9. To uninstall the application

    ```shell
    helm install smart-city-app
    ./clean.sh
    ```

## Execution within A Network Edge Context

The Smart City sample application when executed within a network edge context, it is deployed across multiple regional offices (OpenNESS edge nodes). Each office is an aggregation point of multiple IP cameras (simulated) with their analytics. The media processing and analytics workloads are running on the OpenNESS edge nodes for latency consideration.

The full pipeline of the Smart City sample application on OpenNESS is distributed across three regions:

 1. Client-side Cameras Simulator(s)
 2. OpenNESS Cluster
 3. Smart City Cloud Cluster

The Smart City setup with OpenNESS should typically deployed as shown in this Figure. The drawing depicts 2 offices for the purpose of this guide, but there is no limitation to the number of offices.

![Smart City Setup](setup.png)
_Figure - Smart City Setup with OpenNESS_


### Configuring OpenNESS

After [Installing OpenNESS](#installing-openness), from the OpenNESS Controller CLI, attach the physical ethernet interface to be used for dataplane traffic using the `interfaceservice` kubectl plugin by providing the office hostname and the PCI Function ID corresponding to the ethernet interface (the PCI ID below is just a sample and may vary on other setups):

```shell
kubectl interfaceservice get <officeX_host_name>
...
0000:86:00.0  |  3c:fd:fe:b2:42:d0  |  detached
...

kubectl interfaceservice attach <officeX_host_name> 0000:86:00.0
...
Interface: 0000:86:00.0 successfully attached
...

kubectl interfaceservice get <officeX_host_name>
...
0000:86:00.0  |  3c:fd:fe:b2:42:d0  |  attached
...
```

> **NOTE:** When adding office 2 and so on, attach their corresponding physical interfaces accordingly.

### Building Smart City ingredients

1. Clone the Smart City Reference Pipeline source code from [GitHub](https://github.com/OpenVisualCloud/Smart-City-Sample.git) to: (1) Camera simulator machines, (2) OpenNESS Controller machine, and (3) Smart City cloud master machine.

2. Build the Smart City application on all of the machines as explained in [Smart City deployment on OpenNESS](https://github.com/OpenVisualCloud/Smart-City-Sample/tree/openness-k8s/deployment/openness). At least 2 offices (edge nodes) must be installed on OpenNESS.

### Running Smart City

1. On the Camera simulator machines, assign IP address to the ethernet interface which the dataplane traffic will be transmitted through to the edge office1 & office2 nodes:

    On camera-sim1:
    ```shell
    ip a a 192.168.1.10/24 dev <office1_interface_name>
    route add -net 10.16.0.0/24 gw 192.168.1.1 dev <office1_interface_name>
    ```

    > **NOTE:** When adding office 2 and so on, change the CIDR (i.e: `192.168.1.0/24`) to corresponding subnet. Allocated subnets to individual offices can be retrieved by entering this command in the OpenNESS controller shell:
    > ```shell
    > kubectl get subnets
    > ```
    >
    > The subnet name represents the node which is allocated to it and appended with `-local`.


    On camera-sim2:
    ```shell
    ip a a 192.168.2.10/24 dev <office2_interface_name>
    route add -net 10.16.0.0/24 gw 192.168.2.1 dev <office2_interface_name>
    ```

2. On the Camera simulator machines, run the camera simulator containers
    ```shell
    make start_openness_camera
    ```

3. On the Smart City cloud master machine, run the Smart City cloud containers
    ```shell
    make start_openness_cloud
    ```

    > **NOTE**: At the time of writing this guide, there was no firewall rules defined for the camera simulators & Smart City cloud containers. If none is defined, firewall must be stopped or disabled before continuing. All communication back to the office nodes will be blocked. Run the below on both machines.
    > ```shell
    > systemctl stop firewalld
    > ```

    > **NOTE**: Do not stop firewall on OpenNESS nodes.

4. On the OpenNESS Controller machine, build & run the Smart City cloud containers
    ```shell
    export CAMERA_HOSTS=192.168.1.10,192.168.2.10
    export CLOUD_HOST=<cloud-master-node-ip>

    make
    make update
    make start_openness_office
    ```

    > **NOTE**: `<cloud-master-node-ip>` is where the Smart City cloud master machine can be reached on the management/cloud network.

5. From the web browser, launch the Smart City web UI at URL `https://<cloud-master-node-ip>/`

## References
- [OpenNESS Smart City application whitepaper](https://github.com/otcshare/specs/blob/master/doc/applications/openness_ovc.md)
- [Intel Open Visual Cloud Smart City reference pipeline](https://github.com/OpenVisualCloud/Smart-City-Sample)
- [Intel Open Visual Cloud VCAC-A card media analytics software](https://github.com/OpenVisualCloud/VCAC-SW-Analytics/)
