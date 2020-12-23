#! /bin/bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

echo "Pre-Installation steps for SDEWAN CNF"

# CNF_NODE variable holds the name of the node where CNF will be deployed
# must be set before running the script 
CNF_NODE=""

if [ -z "$CNF_NODE" ]
then
  echo -e "\tVariables CNF_NODE is not set"
  exit 1
fi

# label the node where SDEWAN CNF will be deployed
function label_cnf_node {
    kubectl label nodes $CNF_NODE sdewan=true --overwrite

}

label_cnf_node 

