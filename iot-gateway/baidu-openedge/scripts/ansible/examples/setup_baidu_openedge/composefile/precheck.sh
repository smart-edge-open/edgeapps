#!/usr/bin/env bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2019 Intel Corporation

# check democfg directory

BASE_PATH="$( cd "$(dirname "$0")" ; pwd -P )"

echo "Starting check whether certification and configuraiton files exsit in the democfg" 
if [ -d "${BASE_PATH}/democfg/agent-cert" ];  then 
   if [ ! -f "${BASE_PATH}/democfg/agent-cert/client.key"  ]; then
      echo "Error: no client.key in the agent-cert directory."
      exit 1
   fi
   if [ ! -f "${BASE_PATH}/democfg/agent-cert/client.pem"  ]; then
      echo "Error: no client.pem in the agent-cert directory."
      exit 1
   fi
   if [ ! -f "${BASE_PATH}/democfg/agent-cert/openapi.pem"  ]; then
      echo "Error: no openapi.pem in the agent-cert directory."
      exit 1
   fi
   if [ ! -f "${BASE_PATH}/democfg/agent-cert/root.pem" ]; then
      echo "Error: no root.pem  in the agent-cert directory."
      exit 1
   fi
else
    echo "Error: no agent-cert directory."
    exit 1
fi

if [ -d "${BASE_PATH}/democfg/agent-conf" ];  then 
   if [ ! -f "${BASE_PATH}/democfg/agent-conf/service.yml"  ]; then
      echo "Error: no service.yml in the agent-conf directory."
      exit 1
   fi
else
    echo "Error: no agent-conf directory."
    exit 1
fi

if [ -d "${BASE_PATH}/democfg/remote-iothub-conf" ];  then 
   if [ ! -f "${BASE_PATH}/democfg/remote-iothub-conf/service.yml"  ]; then
      echo "Error: no service.yml in the remote-iothub-conf directory."
      exit 1
   fi
else
    echo "Error: no remote-iothub-conf directory."
    exit 1
fi

if [ ! -f "${BASE_PATH}/democfg/application.yml" ]; then
    echo "Error: no application.yml in the democfg directory."
    exit 1
fi

echo "Completed check. All required files exist" 
