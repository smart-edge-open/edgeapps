```
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2022 Accuknox
```

# KubeArmor
KubeArmor is a cloud-native runtime security enforcement system that restricts the behavior (such as process execution, file access, and networking operations) of containers and nodes (VMs) at the system level.

KubeArmor leverages Linux security modules (LSMs) such as AppArmor, SELinux, or BPF-LSM) to enforce the user-specified policies. KubeArmor generates alerts/telemetry events with container/pod/namespace identities by leveraging eBPF.

## Deploying KubeArmor

### Loading Docker Images
Pull and load appropriate KubeArmor release from https://hub.docker.com/r/kubearmor/kubearmor/tags  

## Install KubeArmor

Install KubeArmor using helm

```
helm upgrade --install kubearmor . \
    --set kubearmorrelay.enabled=true \
    --set namespace.name=<namespace> \
    --set environment.name=<environment>
```
* kubearmorrelay.enabled = {true | false} (default: true)
* namespace.name = [namespace name] (default: kube-system)
* environment.name = {generic | docker | microk8s | minikube | k3s} (default: generic) / use 'generic' for GKE and EKS

Check if all the pods are up and running

```
kubectl get all -n <namespace>
```

## Remove KubeArmor

Uninstall KubeArmor using helm

```
helm uninstall kubearmor
```

## Additional Information

Learn more about KubeArmor at https://kubearmor.io/  
For purchasing query please reach us out at https://www.accuknox.com/contact-us

### Related material
https://help.accuknox.com/