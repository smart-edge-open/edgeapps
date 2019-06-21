#!/usr/bin/env bash
# Copyright 2019 Intel Corporation and Smart-Edge.com, Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# check democfg directory

currdir=${PWD##*/}
BASE_PATH="$( cd "$(dirname "$0")" ; pwd -P )"

echo "Starting check whether certification and configuraiton files exsit in the democfg" 
if [ -d "${BASE_PATH}/democfg/agent-cert" ];  then 
   if [ ! -f ${BASE_PATH}/democfg/agent-cert/client.key  ]; then
      echo "Error: no client.key in the agent-cert directory."
      exit 1
   fi
   if [ ! -f ${BASE_PATH}/democfg/agent-cert/client.pem  ]; then
      echo "Error: no client.pem in the agent-cert directory."
      exit 1
   fi
   if [ ! -f ${BASE_PATH}/democfg/agent-cert/openapi.pem  ]; then
      echo "Error: no openapi.pem in the agent-cert directory."
      exit 1
   fi
   if [ ! -f ${BASE_PATH}/democfg/agent-cert/root.pem ]; then
      echo "Error: no root.pem  in the agent-cert directory."
      exit 1
   fi
else
    echo "Error: no agent-cert directory."
    exit 1
fi

if [ -d "${BASE_PATH}/democfg/agent-conf" ];  then 
   if [ ! -f ${BASE_PATH}/democfg/agent-conf/service.yml  ]; then
      echo "Error: no service.yml in the agent-conf directory."
      exit 1
   fi
else
    echo "Error: no agent-conf directory."
    exit 1
fi

if [ -d "${BASE_PATH}/democfg/remote-iothub-conf" ];  then 
   if [ ! -f ${BASE_PATH}/democfg/remote-iothub-conf/service.yml  ]; then
      echo "Error: no service.yml in the remote-iothub-conf directory."
      exit 1
   fi
else
    echo "Error: no remote-iothub-conf directory."
    exit 1
fi

if [ ! -f ${BASE_PATH}/democfg/application.yml ]; then
    echo "Error: no application.yml in the democfg directory."
    exit 1
fi

echo "Completed check. All required files exist" 
