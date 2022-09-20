```text
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2020 Intel Corporation
```

## OpenVINO HDDL Sample Application in OpenNESS SDEWAN E2E Scenario

This sample application demonstrates OpenVINO object detection (pedestrian and vehicle detection) deployment and execution on the OpenNESS edge platform by HDDL accelerator card.

- [OpenVINO Sample Application White Paper](https://github.com/smart-edge-open/specs/blob/master/doc/applications/openness_openvino.md)
- [OpenVINO Sample Application Onboarding Guide - Network Edge](https://github.com/smart-edge-open/specs/blob/master/doc/applications-onboard/network-edge-applications-onboarding.md#onboarding-openvino-application)

### Deploy Openness With HDDL Enable

   ```
   sed -i -e "s/ne_hddl_enable:.*/ne_hddl_enable: True/" group_vars/all/10-default.yml
   git grep "ne_hddl_enable:.*"
   ```

### Build Benchamrk Image

1. Clone edgeapp on both controller and node machine:

   In E2E scenarios we deploy controller and node on one host.

   ```
   GIT_HTTP_PROXY=http://proxy-mu.intel.com:911
   GIT_USER=YouGitName
   git clone https://github.com/smart-edge-open/edgeapps.git \
   --config "http.proxy=$GIT_HTTP_PROXY" \
   --config "credential.username=$GIT_USER"

   ```

2. Build benchmark image:


   ```
   cd edgeapps/applications/openvino/benchmark/
   sh build_image.sh
   cd -
   ```

### Configure Benchmark Parameters


   ```
   APP_PATH=edgeapps/network-functions/sdewan_cnf/e2e-scenarios/openvino-hddl-cluster
   # You can change the expect parameters in ${APP_PATH}/global_vars.sh
   source ${APP_PATH}/global_vars.sh
   ```

### Run Benchmark Job


   ```
   sh ${APP_PATH}/run_benchmark.sh
   ```

### Collect Environment and Benchmark Results

   ```
   sh ${APP_PATH}/collection.sh
   ls benchmark/openvino/hddl
   ```

### REF

- [Troubleshooting](https://github.com/smart-edge-open/edgeapps/tree/master/applications/openvino/benchmark#troubleshooting)
