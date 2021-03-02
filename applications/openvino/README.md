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

#### 1. After deployment, OpenVINO sample consumer keeps Crash with error: "proxyconnect tcp: dial tcp i/o timeout", and not able to recover after serveral times restart.

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
#### 2. After deployment, Traffic from external server does not receive in Consumer pod.
Install tcpdump on controller.
Use command to capture log:
```shell
    kubectl ko tcpdump default/openvino-cons-app-xxxx port 5000
```
Pod name could be got use below command:
```shell
    kubectl get po 
```    
Log should as:
```log
06:59:57.086038 IP 192.168.1.10.58786 > 10.16.0.36.5000: Flags [P.], seq 1940984:1941120, ack 1, win 298, options [nop,nop,TS val 216647345 ecr 79868771], length 136
06:59:57.086096 IP 192.168.1.10.58786 > 10.16.0.36.5000: Flags [P.], seq 1941120:1942152, ack 1, win 298, options [nop,nop,TS val 216647346 ecr 79868771], length 1032
06:59:57.086143 IP 192.168.1.10.58786 > 10.16.0.36.5000: Flags [P.], seq 1942152:1943700, ack 1, win 298, options [nop,nop,TS val 216647346 ecr 79868771], length 1548
06:59:57.086188 IP 192.168.1.10.58786 > 10.16.0.36.5000: Flags [P.], seq 1943700:1943829, ack 1, win 298, options [nop,nop,TS val 216647346 ecr 79868771], length 129
06:59:57.086233 IP 192.168.1.10.58786 > 10.16.0.36.5000: Flags [P.], seq 1943829:1947183, ack 1, win 298, options [nop,nop,TS val 216647346 ecr 79868771], length 3354
06:59:57.086286 IP 10.16.0.36.5000 > 192.168.1.10.58786: Flags [.], ack 1943700, win 2641, options [nop,nop,TS val 79868802 ecr 216647345], length 0
06:59:57.086355 IP 10.16.0.36.5000 > 192.168.1.10.58786: Flags [.], ack 1947183, win 2614, options [nop,nop,TS val 79868802 ecr 216647346], length 0
06:59:57.086438 IP 192.168.1.10.58786 > 10.16.0.36.5000: Flags [P.], seq 194718
```
If no log, there should no traffic data received by consumer, so pls check your network policy which allowing ingress traffic on port 5000 (tcp and udp) from 192.168.1.0/24 network to the OpenVINO consumer application pod as:
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: openvino-policy
  namespace: default
spec:
  podSelector:
    matchLabels:
      app: openvino-cons-app
  policyTypes:
  - Ingress
  ingress:
  - from:
    - ipBlock:
        cidr: 192.168.1.0/24
    ports:
    - protocol: TCP
      port: 5000
    - protocol: UDP
      port: 5000
```
Or you could try to delete default ingress policy:
```shell
    kubectl delete networkpolicies block-all-ingress
```
If data received after delete the ingress policy, there should be something error in your network policy for consumer, please check and re-apply it. (block-all-ingress should not be deleted in normal step, it is only for debug.)
