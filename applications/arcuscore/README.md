```text
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2021 Blue Arcus Technologies, Inc
```

# Overview of Blue Arcus
Blue Arcus® is a global end-to-end mobile network software provider, delivering telecom solutions that are 3GPP compliant and built on an open and distributed architecture. Blue Arcus® converged core is a unified multi-technology, scalable, carrier-grade and modular end-to-end network solution that helps vendors the flexibility to build their network solutions. Our 4G/5G Converged Core offers mobile network operators and solution integrators to deploy specific use cases tailored for Consumer, IoT, Private LTE/5G, Fixed Wireless, MEC and LBO networks. With many live deployments across the Pacific, Asia, Middle East, and Africa, we have been helping MNOs enhance customer experience by providing cost-effective, fast, and reliable voice and data services. The SMART Compact network edge of the core makes it suitable for delivering high speed, secure and low-latency services. Blue Arcus® is headquartered in the USA and has worldwide supported clients in all time zones and geographies.
For more information, please visit our official website: https://www.bluearcus.com/

# **Arcus Core Description**
Arcus Core is a unified multi-technology, carrier grade and 3GPP compliant standard solution. Built on an open Architecture, the Arcus core enables seamless integration to external elements. Arcus Converged Core is a 2G/3G/4G/5G end to end virtualized & cloud native solution, flexible to accommodate new customer requirement due to the compact size and space optimization. Autoscaling and high availability is assured through policies configured by taking advantage of Virtualized and cloud native architecture.
The components of Arcus 4G/5G core and functionality:
•	Mobility Manager: MME/AMF
•	Subscriber Manager: HSS/UDM
•	Packet Gateway: SPGW/SMF/UPF
•	Policy & Charging: PCF / PCRF
•	Voice Services: VoLTE, VoNR
•	Authentication Function: AUSF, AUC

## **Pre Requisites – Resources Required**

| **Resource Information**           |                                              |
|------------------------------------|----------------------------------------------|
| Application Type                   | 5G Core Network                              |
| CPU                                | Intel core processor 6th Generation or newer.|   
| Compute  (vCores)                  | 12                                           |  
| Memory (RAM)                       | 24 GB                                        |  
| Storage 			     | 200  GB                                      |  
| Host OS                            | CentOS 7.9.2009                              | 
  


## **Where to Purchase**
Contact marketing@bluearcus.com


## Pre Requisites - Installing OpenNESS

|**Configuration**                   |                                |
|  ----------------------------------|--------------------------------|
| OpenNESS Version                   | 21.03.05		              |
| Flavor Used 		             | CERA Core User Plane Flavor    |
| Distribution			     | Intel Distribution of OpenNESS |


Follow below link to setup controller and edge-node for installing OpenNESS.

## Loading Docker Images
docker image load -i amf_image_v1.1.3.tar 
docker image load -i ausf_image_1_1_5.tar 
docker image load -i pcf_image_1_0_14.tar
docker image load -i smf_image_1.0.16.tar 
docker image load -i udm_image_1_1_10.tar

## Installing Blue Arcus 5G Core Application using helm

Run the following commands to deploy  through helm:

`helm install 5gcore . -n 5gcore`

 Sample Output would look like:
> `NAME: 5gcore`
>
> `LAST DEPLOYED: `
>
> `NAMESPACE: 5gcore`
>
> `STATUS: deployed`
>
> `REVISION: 1`
>
> `TEST SUITE: None`
>
> `NOTES:`
>
> `# SPDX-License-Identifier: Apache-2.0`
>
> `# Copyright (c) 2021 Blue Arcus Technologies, Inc`
>
> `5gcore was installed.`
>
> `Your release is named 5gcore.`
>
> `To learn more about the release, try:`
>
> `  $ helm status 5gcore -n 5gcore`


## Uninstall Blue Arcus 5G Core
To uninstall application run below command:
    
`helm uninstall 5gcore -n 5gcore`

## Testing Steps
For further instructions about steps for testing, contact Support (marketing@bluearcus.com)

## **Related material**
* www.bluearcus.com

