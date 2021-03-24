#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

pci_nic_ports=$CONFIG_PCI_BUS_ADDR
huge_page_memory=$CONFIG_HUGE_MEMORY        
main_core=$CONFIG_MAIN_CORE
worker_cores=$CONFIG_WORKER_CORES
pfcp_thread_cores=$CONFIG_PFCP_THREAD_CORES        
no_of_pfcp_threads=$CONFIG_NO_OF_PFCP_THREADS        

# Inferface names, ex: VirtualFunctionEthernetaf/a/0
n3_iface=$CONFIG_VFIF_NAME
n6_iface=$CONFIG_VFIF_NAME

# Ip address along with the subnet ex:192.168.1.170/24
n3_ip=$CONFIG_N3_IP_ADDR
n6_ip=$CONFIG_N6_IP_ADDR


# remove the subnet from the n3_ip address
n3_ip_plain=$(echo "$n3_ip" | awk -F'/' '{ print $1 }')
# n4 ip address without subnet
n4_ip=$CONFIG_N4_IP_ADDR
# Gateway IP address
n6_gw_ip=$CONFIG_N6_GW_IP_ADDR

upf_path=/home/upf

uio_drv=$CONFIG_UIO_DRIVER       


############################################
# NOTE1: start FIXME
# Below steps should run on node host. 
# We can not include them in this script, as this script will
# run in side docker. 
###########################################
#modprobe vfio-pci
#for dev in $pci_nic_ports; 
#do
#	#./install-vpp-native/external/share/dpdk/usertools/dpdk-devbind.py --status 
#	ifname=$(./install-vpp-native/external/share/dpdk/usertools/dpdk-devbind.py --status | grep "$dev" | egrep -e 'if=[^ ,]*' -o | sed -e 's/^.*=//')
#	[ ! -z "$ifname" ] && ifconfig $ifname down
#	./install-vpp-native/external/share/dpdk/usertools/dpdk-devbind.py -b $uio_drv $dev
#	#./install-vpp-native/external/share/dpdk/usertools/dpdk-devbind.py --status
#done

############################################
# NOTE1: End
###########################################


upf_config=/tmp/upf.conf
rm -f $upf_config
#default edgeapp config:
if [ -z "$CONFIG_N3_IF_NAME" ] && [ -z "$CONFIG_N4_IF_NAME" ]
then
cat <<EOF > $upf_config

comment {set N6 interface}
set int ip address $n6_iface $n6_ip
set int state $n6_iface up

comment {set N3 interface}
set int ip address $n3_iface $n3_ip
set int state $n3_iface up

comment {set route}             
ip route add 0.0.0.0/0 table 0 via $n6_gw_ip $n6_iface

comment {set N4 pfcp endpoint} 
upf pfcp endpoint ip $n4_ip vrf 0
comment {upf pfcp endpoint ip $n4_ip vrf 0}

upf nwi name epc vrf 0
upf nwi name sgi vrf 0

comment {set N3 gtpu endpoint}
upf gtpu endpoint ip $n3_ip_plain nwi epc TEID-Range-Indication 2

EOF
#I-UPF config:
elif [ -n "$CONFIG_N3_IF_NAME" ] && [ -n "$CONFIG_N4_IF_NAME" ]
then
cat <<EOF > $upf_config

comment {set N6 interface}
set int ip address $n6_iface $n6_ip
set int state $n6_iface up

comment {set N3 interface}
set interface mac address $CONFIG_N3_IF_NAME $CONFIG_N3_IF_MAC
set int ip address $CONFIG_N3_IF_NAME $CONFIG_N3_IP_ADDR
set int state $CONFIG_N3_IF_NAME up

comment {set N4 interface}
set int ip address $CONFIG_N4_IF_NAME ${CONFIG_N4_IP_ADDR}/24
set int state $CONFIG_N4_IF_NAME up

comment {set route}             
ip route add 0.0.0.0/0 table 0 via $n6_gw_ip $n6_iface

comment {set N4 pfcp endpoint} 
upf pfcp endpoint ip $CONFIG_N4_IP_ADDR vrf 0
comment {upf pfcp endpoint ip $CONFIG_N4_IP_ADDR vrf 0}

upf nwi name epc vrf 0
upf nwi name sgi vrf 0

comment {set N3 gtpu endpoint}
upf gtpu endpoint ip $n3_ip_plain nwi epc TEID-Range-Indication 2

EOF
#PSA-UPF config:
elif [ -z "$CONFIG_N3_IF_NAME" ] && [ -n "$CONFIG_N4_IF_NAME" ]
then
cat <<EOF > $upf_config

comment {set N6 interface}
set int ip address $n6_iface $n6_ip
set int state $n6_iface up

comment {set N3 interface}
set int ip address $CONFIG_N4_IF_NAME ${CONFIG_N4_IP_ADDR}/24
set int state $CONFIG_N4_IF_NAME up

comment {set route}             
ip route add 0.0.0.0/0 table 0 via $n6_gw_ip $n6_iface

comment {set N4 pfcp endpoint} 
upf pfcp endpoint ip $CONFIG_N4_IP_ADDR vrf 0
comment {upf pfcp endpoint ip $CONFIG_N4_IP_ADDR vrf 0}

upf nwi name epc vrf 0
upf nwi name sgi vrf 0

comment {set N3 gtpu endpoint}
upf gtpu endpoint ip $CONFIG_N4_IP_ADDR nwi epc TEID-Range-Indication 2

EOF
fi
#the and of the config is common:
cat <<EOF >> $upf_config
comment {for pfcp-thread}
upf enable-disable

comment {debug config}
comment {set upf log level info}
comment {set upf log level fatal}
set upf log level debug

comment {set logging class upf level debug syslog-level debug rate-limit 650}
set logging class upf level debug syslog-level debug rate-limit 650

comment {upf detect-method bdt}
comment {session enable}
EOF


upf_vpp_config=/tmp/upf_vpp.conf

rm -f $upf_vpp_config
cat <<EOF > $upf_vpp_config
##mallocheap 1
heapsize $huge_page_memory

unix {
  #nodaemon
  interactive cli-listen /run/vpp/cli.sock
  log /var/log/vpp/vpp.log
  full-coredump
  gid vpp
  exec $upf_config
}
#ulimit -c unlimited
api-trace {
## This stanza controls binary API tracing. Unless there is a very strong reason,
## please leave this feature enabled.
  on
## Additional parameters:
##
## To set the number of binary API trace records in the circular buffer, configure nitems
##
## nitems <nnn>
##
## To save the api message table decode tables, configure a filename. Results in /tmp/<filename>
## Very handy for understanding api message changes between versions, identifying missing
## plugins, and so forth.
##
## save-api-table <filename>
}

api-segment {
  gid vpp
}

socksvr {
  default
}

cpu {
	## In the VPP there is one main thread and optionally the user can create worker(s)
	## The main thread and worker thread(s) can be pinned to CPU core(s) manually or automatically

	## Manual pinning of thread(s) to CPU core(s)

	## Set logical CPU core where main thread runs, if main core is not set
	## VPP will use core 1 if available
	##main-core 1
	main-core $main_core

	## Set logical CPU core(s) where worker threads are running
	corelist-workers $worker_cores

	corelist-pfcp-threads $pfcp_thread_cores

	## Automatic pinning of thread(s) to CPU core(s)

	## Sets number of CPU core(s) to be skipped (1 ... N-1)
	## Skipped CPU core(s) are not used for pinning main thread and working thread(s).
	## The main thread is automatically pinned to the first available CPU core and worker(s)
	## are pinned to next free CPU core(s) after core assigned to main thread
	#skip-cores 1

	## Specify a number of workers to be created
	## Workers are pinned to N consecutive CPU cores while skipping "skip-cores" CPU core(s)
	## and main thread's CPU core
	#workers 2

        # number of pfcp threads
        pfcp-threads $no_of_pfcp_threads


	## Set scheduling policy and priority of main and worker threads

	## Scheduling policy options are: other (SCHED_OTHER), batch (SCHED_BATCH)
	## idle (SCHED_IDLE), fifo (SCHED_FIFO), rr (SCHED_RR)
	# scheduler-policy fifo

	## Scheduling priority is used only for "real-time policies (fifo and rr),
	## and has to be in the range of priorities supported for a particular policy
	# scheduler-priority 50
}

dpdk {
	## Change default settings for all intefaces
	dev default {
		## Number of receive queues, enables RSS
		## Default is 1
		#num-rx-queues 8

		## Number of transmit queues, Default is equal
		## to number of worker threads or 1 if no workers treads
		#num-tx-queues 8

		## Number of descriptors in transmit and receive rings
		## increasing or reducing number can impact performance
		## Default is 1024 for both rx and tx
		# num-rx-desc 512
		# num-tx-desc 512

		## VLAN strip offload mode for interface
		## Default is off
		# vlan-strip-offload on
	}

	## Whitelist specific interface by specifying PCI address
	#dev 0000:18:00.0
	#dev 0000:18:00.1
	## Whitelist specific interface by specifying PCI address and in
	## addition specify custom parameters for this interface

	#FIXME for multiple NIC ports support
	dev $pci_nic_ports {
                num-rx-queues 1
                num-rx-desc 2048
				#ddp-enabled
				#flow-control high 940 low 920 pause 50 xon 1
                #workers 0 1 2 3 4 5 6 7
                #num-rx-desc 4096
    }


EOF

if [ -n "$CONFIG_N3_PCI_BUS_ADDR" ]
then
cat <<EOF >> $upf_vpp_config

	dev $CONFIG_N3_PCI_BUS_ADDR {
                num-rx-queues 1
                num-rx-desc 2048
				#ddp-enabled
				#flow-control high 940 low 920 pause 50 xon 1
                #workers 0 1 2 3 4 5 6 7
                #num-rx-desc 4096
    }

EOF
fi

if [ -n "$CONFIG_N4_PCI_BUS_ADDR" ]
then
cat <<EOF >> $upf_vpp_config

	dev $CONFIG_N4_PCI_BUS_ADDR {
                num-rx-queues 1
                num-rx-desc 2048
				#ddp-enabled
				#flow-control high 940 low 920 pause 50 xon 1
                #workers 0 1 2 3 4 5 6 7
                #num-rx-desc 4096
    }

EOF
fi

cat <<EOF >> $upf_vpp_config

	## Specify bonded interface and its slaves via PCI addresses
	##
	## Bonded interface in XOR load balance mode (mode 2) with L3 and L4 headers
	# vdev eth_bond0,mode=2,slave=0000:02:00.0,slave=0000:03:00.0,xmit_policy=l34
	# vdev eth_bond1,mode=2,slave=0000:02:00.1,slave=0000:03:00.1,xmit_policy=l34
	##
	## Bonded interface in Active-Back up mode (mode 1)
	# vdev eth_bond0,mode=1,slave=0000:02:00.0,slave=0000:03:00.0
	# vdev eth_bond1,mode=1,slave=0000:02:00.1,slave=0000:03:00.1

	## Change UIO driver used by VPP, Options are: igb_uio, vfio-pci,
	## uio_pci_generic or auto (default)
	uio-driver $uio_drv

	## Disable mutli-segment buffers, improves performance but
	## disables Jumbo MTU support
	# no-multi-seg

	## Increase number of buffers allocated, needed only in scenarios with
	## large number of interfaces and worker threads. Value is per CPU socket.
	## Default is 16384
	#num-mbufs 262144

	## Change hugepages allocation per-socket, needed only if there is need for
	## larger number of mbufs. Default is 256M on each detected CPU socket

	#FIXME should be taken from huge_page_memory param
	socket-mem 4096,4096

	## Disables UDP / TCP TX checksum offload. Typically needed for use
	## faster vector PMDs (together with no-multi-seg)
	# no-tx-checksum-offload
	# enable-tcp-udp-checksum
}

statseg {
  size 256M
}

plugins {
   #path /usr/src/vpp/build-root/install-vpp-native/vpp/lib/vpp_plugins/
    #plugin dpdk_plugin.so { disable }
    #plugin gtpu_plugin.so { disable }
    #plugin vmxnet3_plugin.so { disable }
    #plugin upf_plugin.so { enable }
	## Adjusting the plugin path depending on where the VPP plugins are
	#	path /home/bms/vpp/build-root/install-vpp-native/vpp/lib64/vpp_plugins

	## Disable all plugins by default and then selectively enable specific plugins
	# plugin default { disable }
	# plugin dpdk_plugin.so { enable }
	# plugin acl_plugin.so { enable }

	## Enable all plugins by default and then selectively disable specific plugins
	#plugin dpdk_plugin.so { disable }
	#plugin upf_plugin.so { enable }
	plugin  ioam_plugin.so           { disable }
    plugin  crypto_ipsecmb_plugin.so { disable }
	plugin  nsh_plugin.so            { disable }
	plugin  avf_plugin.so            { disable }
	plugin  pppoe_plugin.so          { disable }
	plugin  abf_plugin.so            { disable }
	plugin  srv6am_plugin.so         { disable }
	plugin  ila_plugin.so            { disable }
	plugin  l2e_plugin.so            { disable }
	plugin  tlsopenssl_plugin.so     { disable }
	plugin  map_plugin.so            { disable }
	plugin  stn_plugin.so            { disable }
	plugin  acl_plugin.so            { disable }
	plugin  crypto_openssl_plugin.so { disable }
	plugin  tlsmbedtls_plugin.so     { disable }
	plugin  ikev2_plugin.so          { disable }
	plugin  ct6_plugin.so            { disable }
	plugin  cdp_plugin.so            { disable }
	#plugin  lacp_plugin.so           { disable }
	plugin  flowprobe_plugin.so      { disable }
	plugin  svs_plugin.so            { disable }
	plugin  nsim_plugin.so           { disable }
	plugin  mactime_plugin.so        { disable }
	plugin  lb_plugin.so             { disable }
	plugin  quic_plugin.so           { disable }
	plugin  crypto_ia32_plugin.so    { disable }
	plugin  srv6as_plugin.so         { disable }
	plugin  srv6ad_plugin.so         { disable }
	plugin  rdma_plugin.so           { disable }
	plugin  vmxnet3_plugin.so        { disable }
	plugin  gbp_plugin.so            { disable }
	plugin  igmp_plugin.so           { disable }
	plugin  nat_plugin.so            { disable }
	plugin  gtpu_plugin.so           { disable }
 }

	## Alternate syntax to choose plugin path
	# plugin_path /home/bms/vpp/build-root/install-vpp-native/vpp/lib64/vpp_plugins

EOF

rm -rf /run/dpdk/ /dev/shm/*
mkdir -p /var/log/vpp/
mkdir -p /tmp/vpp/
touch /var/log/vpp/vpp.log
mkdir -p /tmp/dumps
#sudo sysctl -w debug.exception-trace=1 
#sudo sysctl -w kernel.core_pattern="/tmp/dumps/%e-%t"
#ulimit -c unlimited
echo 2 > /proc/sys/fs/suid_dumpable

#export LD_LIBRARY_PATH=$upf_path/install-vpp-native/vpp/lib:$LD_LIBRARY_PATH
#echo "PATH=$PATH:$upf_path/install-vpp-native/vpp/bin/" >> /root/.bashrc
#echo "export LD_LIBRARY_PATH=$upf_path/install-vpp-native/vpp/lib:$LD_LIBRARY_PATH" >> /root/.bashrc

#$upf_path/install-vpp-native/vpp/bin/vpp -c $upf_vpp_config

export LD_LIBRARY_PATH=$upf_path/install-vpp-native/vpp/lib:$LD_LIBRARY_PATH
echo "=========== Start =========" > /home/upf/run.log

echo "$LD_LIBRARY_PATH" >> $upf_path/run.log
echo "at step-1" >> $upf_path/run.log
cd $upf_path || exit
echo "at step-2" >> $upf_path/run.log
pwd >> $upf_path/run.log

#screen -dmS vpp_UPF1 ./install-vpp-native/vpp/bin/vpp -c config/startup-1907-NO-bond-upf1.conf
$upf_path/install-vpp-native/vpp/bin/vpp -c $upf_vpp_config


