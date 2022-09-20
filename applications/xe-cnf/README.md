```
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2021 Exium Inc.
```

# **Overview**

Exium is an American full-stack cybersecurity and 5G clean networking pioneer helping organizations to connect and secure their teams, users, and mission-critical assets with ease, wherever they are.

### **Application Description**

Exium’s 5G Secure Access Services Edge (SASE) is built on an open, programmable, reliable, and software-driven Intelligent Cybersecurity Mesh™ that enables secure and private end-to-end connectivity and provides the ability to securely operate anywhere and anytime, regardless of the environment, even on underlying networks that may be compromised.

Robust overlay architecture provides the ability to securely operate globally over any underlying network (5G, WiFi, Fiber/ Cable, and satellites).

### **Prerequisites (For deploying Exium Edge Application on OpenNESS)**
Virtual machine(s) or bare metal server(s) with the following minimum hardware resources: 16 vCPUs, 32 GB RAM, 64GB SSD, 100GB HDD for Boot disk. The server also requires Kubernetes based OpenNESS 20.09 or later cluster. Please refer to [user guide](https://xe-releases.s3.us-east-2.amazonaws.com/xe-openness/xe-cnf-install-guide-OpenNESS.pdf) for more details.

### **Exium Edge deployment on OpenNESS**

In reference deployment for Exium’s Secure 5G Core/ MEC. In this deployment, control and management plane is deployed in the public cloud and user plane/ MEC deployed on OpenNESS Clusters. Installation instructions covers deployment of Exium Secured MEC.

Prerequisite 
==============
1. Deploy on single node **Virtual Machine/Bare Metal** server.

| **Node Spec**                     | **Minimum**  |
| --------------------------------- | ------------ |
| Compute (vCores)                  | 16           |
| Memory (RAM)                      | 32 GB        |
| Storage (System minimum)          | 100 GB       |
| Host OS                           | CentOS 7.9   |
| Network                           | 1G/10G       |
| NIC Count                         | 3            |

1. Worker spec:-
   
	a. Worker node should load with vfio driver.  

	 Create below file to load module on boot 

    ```bash
	cat /etc/modules-load.d/vfio.conf
	vfio
	vfio-pci
	```

	b. Worker node should configure with hugepages_sz of 2 MB & hugepage_count to 4096. For hugepage configuration follow : [hugepage configuration](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/virtualization_tuning_and_optimization_guide/sect-Virtualization_Tuning_Optimization_Guide-Memory-Tuning#sect-Virtualization_Tuning_Optimization_Guide-Memory-Huge_Pages-1GB-runtime)

Configure
=========
Edit config.sh file.
--------------------
| **Configuration Parameter**       |**Value Type**|
| --------------------------------- | ------------ |
|istio version| 1.6.8|
| nwu_ip                            | IPv4         |
| nwu_mask                          | Network mask in CIDR Format       |
|nwu_pci_addr|PCI address, get by cmd:  grep PCI_SLOT_NAME /sys/class/net/<interface name>/device/uevent|
|nwu_gw_ip|gateway ip for NWU interface|
|n6_ip|IP address for N6 interface|
|n6_mask|Network mask for N6 interface in CIDR format|
|n6_pci_addr|PCI addrees, get by cmd:  grep PCI_SLOT_NAME /sys/class/net/<interface name>device/uevent|
|n6_gw_ip|gateway ip for n6 interface|

Deploy
======
1. Clone [openness repo for converged-edge-experience-kits](https://github.com/open-ness/converged-edge-experience-kits) to deploy single-node Kubernetes cluster. 

	a. Edit inventory.yml file.
	```bash
	---
	all:
	vars:
		cluster_name: exium_edge    # NOTE: Use `_` instead of spaces.
		flavor: minimal  # NOTE: Flavors can be found in `flavors` directory.
		single_node_deployment: true  # Request single node deployment (true/false).
		limit:                        # Limit ansible deployment to certain inventory group or hosts
	controller_group:
	hosts:
		controller:
		ansible_host: 127.0.0.1 #  Deployed_VM_IP 
		ansible_user: root 
	edgenode_group:
	hosts:
		node01:
		ansible_host: 127.0.0.1 # Deployed_VM_IP
		ansible_user: root
	edgenode_vca_group:
	hosts:
	ptp_master:
	hosts:
	ptp_slave_group:
	hosts:
	```

	b. Run deploy.py to install openness cluster
	```bash
	$ python deploy.py
	```

	c. After openness cluster is deployed, goto xe-cnf directory and execute below commands:
	```bash
	$ sh setup.sh
	```

Uninstall
=========
Run below command to uninstall exium-application.

```bash
sh uninstall.sh
```

For destroying openness cluster, run below command from ansible host:

```bash
python deploy.py --clean
```

Contact
=======
Please write mail to Exium Sales at [support@exium.net](support@exium.net)

Website : [https://www.exium.net](https://www.exium.net)

Signup-URL : [https://service.exium.net/sign-up](https://service.exium.net/sign-up)