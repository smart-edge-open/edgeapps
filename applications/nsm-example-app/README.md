```text
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2021-2022 Intel Corporation
```

# NSE Composition - Network Service Mesh Sample Application

## Overview
NSE-Composition is an example that demonstrates a complex Network Service implemented via a chain of Network Service Endpoints (NSE). The application showcases the mechanism of service chaining with NSM. The service composition used in this example includes endpoints connecting via kernel and memif interfaces, where memif is a high performance mamory based interface available in vpp enabled endpoints.

This application can be deployed on a SEO cluster with Spire and NSM basic example deployments.

- Spire is an implementation of the Secure Production Identity Framework For Everyone (SPIFFE) standard APIs to perform node and workload attestation to securely issue SPIFFE Verifiable Identity Document (SVID) to workloads and verify the SVIDs of other workloads. It provides secure identity to workloads in a distributed systems via x.509 certificates and removes the need for application-level authentication and network-level ACL configuration.

- NSM basic is an example combination and configuration of NSM components: nsmgr, forwarder-vpp, registry-k8s and addmission-webhook-k8s.

## Prerequisites

Deploy Smart Edge Open cluster with `nsm_enabled` set to `true`. The deployment will bring up spire and nsm-system namespace with the basic NSM system components.

## How to configure the NSE Composition Application

Go to file ./nse-composition/values.yml and set the following variables:

- client.nodeSelector.labelValue - node's hostname (cannot be empty)
- nseKernel.nodeSelector.labelValue - node's hostname (cannot be empty)
- nseKernel.container.nse.env.nsmCidrPrefix - cidr prefix that NSE will use to set its own IP address and provide IP addresses to the Network Service Clients. 


## How to deploy the NSE Composition Application

Install the application via Helm chart specifying the namespace that will be created to hold the application resources:

```
$ NAMESPACE=<namespace>
$ helm install nse-composition ./nse-composition --namespace $NAMESPACE --create-namespace
```

Given the name of the namespace is "ns-example", the output should look similar to:

```
$ kubectl get pods -n ns-example
NAMESPACE          NAME                                                        READY   STATUS             RESTARTS            AGE
ns-example         alpine                                                      3/3     Running            0                   23s
ns-example         nse-firewall-vpp-b887fdbd-hqdd2                             1/1     Running            0                   23s
ns-example         nse-kernel-64fdfb6bc6-vj6p8                                 2/2     Running            0                   23s
ns-example         nse-passthrough-1-6f8f6dd77c-wxsp6                          1/1     Running            0                   23s
ns-example         nse-passthrough-2-795fb5d75b-pv9kx                          1/1     Running            0                   23s
ns-example         nse-passthrough-3-846568d875-lwp6x                          1/1     Running            0                   23s
```

## How to test the NSE Composition Application

NOTE: Given the "nsmCidrPrefix" in the Helm chart's ./nse-composition/values.yml file was set to "172.16.1.100/31", run the following tests: 

Select the hostname of the node where Network Service Endpoint (NSE) is deployed:

```
NODE=($(kubectl get nodes -o go-template='{{range .items}}{{ if not .spec.taints  }}{{index .metadata.labels "kubernetes.io/hostname"}} {{end}}{{end}}')[0])
```

Find NSC and NSE pods by labels:

```
NSC=$(kubectl get pods -l app=alpine -n ${NAMESPACE} --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')
NSE=$(kubectl get pods -l app=nse-kernel -n ${NAMESPACE} --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')
```

Ping from NSC to NSE:

```
kubectl exec ${NSC} -n ${NAMESPACE} -- ping -c 4 172.16.1.100
```

Check TCP Port 8080 on NSE is accessible to NSC:

```
kubectl exec ${NSC} -n ${NAMESPACE} -- wget -O /dev/null --timeout 5 "172.16.1.100:8080"
```

Check TCP Port 80 on NSE is inaccessible to NSC:

```
kubectl exec ${NSC} -n ${NAMESPACE} -- wget -O /dev/null --timeout 5 "172.16.1.100:80"
if [ 0 -eq $? ]; then
  echo "error: port :80 is available" >&2
  false
else
  echo "success: port :80 is unavailable"
fi
```
Ping from NSE to NSC:

```
kubectl exec ${NSE} -n ${NAMESPACE} -- ping -c 4 172.16.1.101
```

## How to clean up the application

```
helm uninstall nse-composition -n $NAMESPACE
```
