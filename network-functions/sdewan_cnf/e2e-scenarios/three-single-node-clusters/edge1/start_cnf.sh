#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

# start sdewan cnf with 2 provider networks.

PNET_IFC=net2
PNET_IP=$EDGE1_CNF_NET1_IFIP
PNET_NAME=pnetwork1
ONET_IFC=net3
ONET_IP=$EDGE1_CNF_NET3_IFIP
ONET_NAME=pnetwork2

SDEWAN_VALUES_FILE=./edgeapps/network-functions/sdewan_cnf/chart/sdewan-cnf/values.yaml
sed -i -e 's/\(.*registry:\).*/\1 ""/' $SDEWAN_VALUES_FILE

# provider network seting
sed -i -e ":a;N;\$!ba; s/\(interface: \)\"\"/\1$PNET_IFC/1" $SDEWAN_VALUES_FILE
sed -i -e ":a;N;\$!ba; s/\(ipAddress: \)\"\"/\1$PNET_IP/1" $SDEWAN_VALUES_FILE
sed -i -e ":a;N;\$!ba; s/\(name: \)\"\"/\1$PNET_NAME/1" $SDEWAN_VALUES_FILE
# ovn network seting
sed -i -e ":a;N;\$!ba; s/\(interface: \)/\1$ONET_IFC/2" $SDEWAN_VALUES_FILE
sed -i -e ":a;N;\$!ba; s/\(ipAddress: \)/\1$ONET_IP/2" $SDEWAN_VALUES_FILE
sed -i -e ":a;N;\$!ba; s/\(name: \)/\1$ONET_NAME/3" $SDEWAN_VALUES_FILE
sed -i -e 's/\([^ ]\)""/\1/' $SDEWAN_VALUES_FILE

cd edgeapps/network-functions/sdewan_cnf
helm install sdewan-cnf chart/sdewan-cnf/
cd -
