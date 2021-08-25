```text
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2021 Nabstract.io
```

# **Nabstract.io Overview**
Nabstract.io building up set of network applications that provides the required abstraction layer for developers, application platform owners & MEC / Edge Cloud companies to interface with Mobile Network Providers. Its Nabstract NEF product portfolio enables intelligent policy driven environment for Vertical Industries to operate as service partners to enable & monetize B2B2X business models with Mobile Network Providers.

# **nio_tis Application Description**
NIO_TIS, is a traffic influence 5G Network application. It is part of the Nabstract NEF Portfolio. 
As the CSP/Mobile Network Providers collaborate with different hyper scaler to partner to build the EDGE (MEC) Cloud network, the need to automate dynamic policy environment triggered by a context of device, platform or edge application will get complex & demanding on the MNO. The Nabstract NEF provides a single & independent definition point between application platforms and 5G Core deployment to address this issue. The Nabstract NEF with its portfolio of network applications& APIs address this issue, provides a common, unified network exposure platform for Mobile Network as a critical building block in the B2B2X business model and partnerships.

# **OpenNESS Building Blocks**
NIO_TIS leverages Intel OpenNESS Microservices and provides a 5G AF enabler Portal and Rule Engine to define traffic influence rules.

## **Pre Requisites – Resources Required**

This document assumes that the Intel openness was installed through the openness playbook. Single Node or Multiple Node deployment.

| **OpenNESS IDO**           |                                |
|----------------------------|--------------------------------|
| version                    | 21.03.05		                    | 
| flavor                     | CERA Core Control Plane Flavor |  

**Note: The other components may need IDO distribution.**

| **Resource Information**           |                      |
|------------------------------------|----------------------|
| Helm                               | v3.1.2		            | 
| Host OS                            | CentOS 7.9.2009      |  
| Compute* (vCores)                  | Minimum 4 to 8       |  
| RAM 				                       | Minimum 8GB          |  
| Storage                            | 100GB SSD            | 
| CPU                                | Intel Xeon scalable Processors |
  
## **Where to Purchase**
Contact info@nabstract.io

## Installing nio_tis Application using helm

The NIO_TIS is available in the open-ness/edgeapps repository. To obtain it, just clone the repo.

`$git clone https://github.com/open-ness/edgeapps`


 Then, into applications/nio_tis folder there is helm chart folder for installing it.

`$cd nio_tis `

 Install the Chart

`helm install niotis ./niotis/`

 Sample Output would look like:
 
> `NAME: niotis`
> 
> `LAST DEPLOYED: Mon Jul 12 11:14:41 2021`
> 
> `NAMESPACE: default`
> 
> `STATUS: deployed`
> 
> `REVISION: 1`
> 
> `NOTES:1`
> 
> `# SPDX-License-Identifier: Apache-2.0`
> 
> `# Copyright (c) 2021 Nabstract.io`
> 
> `1. Get the application URL by running these commands:
  export NODE_PORT=$(kubectl get --namespace default -o jsonpath="{.spec.ports[0].nodePort}" services niotis)
  export NODE_IP=$(kubectl get nodes --namespace default -o jsonpath="{.items[0].status.addresses[0].address}")
  echo http://$NODE_IP:$NODE_PORT`

## Uninstall nio_tis application
To uninstall application run below command:
    
`helm uninstall niotis`

## **Additional Information**
NIO_TIS is part of the Nabstract NEF Product Portfolio, and it is the first service launched. Nabstract will release other NEF services periodically.  


## **Related material**
https://networkbuilders.intel.com/solutionslibrary/nabstract-traffic-influence-service-will-automate-mec-traffic
https://www.nabstract.io/
