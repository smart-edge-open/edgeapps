```text
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2020 Intel Corporation
```

## OpenVINO Sample Application in OpenNESS

### Overview
This sample application demonstrates OpenVINO object detection (pedestrian and vehicle detection) deployment and execution on the OpenNESS edge platform.

- [OpenVINO Sample Application White Paper](https://github.com/otcshare/specs/blob/master/doc/applications/openness_openvino.md)
- [OpenVINO Sample Application Onboarding Guide - Network Edge](https://github.com/otcshare/specs/blob/master/doc/applications-onboard/network-edge-applications-onboarding.md#onboarding-openvino-application)
- [OpenVINO Sample Application Onboarding Guide - On-premises](https://github.com/otcshare/specs/blob/master/doc/applications-onboard/on-premises-applications-onboarding.md#onboarding-openvino-applications)


### Troubleshooting

#### After deployment, OpenVINO sample consumer keeps Crash with error: "proxyconnect tcp: dial tcp i/o timeout", and not able to recover after serveral times restart.

The issue is caused by proxy setting issue. Modify proxy setting when building image or Edit 'openvino-cons-app.yaml' with desired proxy setting as below:
```yaml
      containers:
        - name: openvino-cons-app
          image: openvino-cons-app:1.0
          imagePullPolicy: Never
          env:
          - name: https_proxy
            value: "<proxy>"

```

If the issue still exists, can try to re-deploy as below:
```shell
# kubectl delete -f openvino-cons-app.yaml
# kubectl delete csr openvino-cons-app 

```

Then re-deploy after the consumer has been terminated completely (Use `kubectl get pods` to check termination status).  
