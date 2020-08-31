```text
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2020 Intel Corporation
```

# VAS Sample Application in OpenNESS

This sample application demonstrates VAS consumer sample application deployment and execution on the OpenNESS edge platform with VAS enabled.


# Introduction
## Directory Structure
- `/cmd` : Main applications inside.
- `/build` : Building scripts in the folder.
- `/deployments` : Helm Charts and K8s yaml files inside.


## Quick Start
### To build sample application container image:

```sh
./build/build-image.sh
```

After build image, you can directly push the image to docker registry on the controller:

```sh
docker push <controller_ip>:5000/vas-cons-app:1.0
```

Or you can directly build image on the edgenode.


### To deploy and test the sample application:

- Make sure the sample application images built and reachable 
- Two method for the deployment on the openness edge node
  - Use the command ```kubectl apply``` with the yaml file ```vas-cons-app.yaml``` in the folder - deployments/yaml
  - Or use helm charts in the folder - deployments/helm
- Check Results by ```kubectl logs```
NOTE: If image pushed to docker registry on the controller, you need to edit: ```deployments/helm/values.yaml``` or ```deployments/yaml/vas-cons-app.yaml``` - change ```repository``` to IP address of Docker Registry .


### To check test results:

1. check whether the application pod is successfully deployed.
```sh
# kubectl get pods -A | grep vas-cons-app
default       vas-cons-app                                0/1     Completed   0          30h
```

2. check the pod's logs as below expected results:

```sh
# kubectl logs vas-cons-app
2020/06/29 01:37:25 Video-analytics-service Consumer Started
2020/06/29 01:37:25 CSR Started
2020/06/29 01:37:25 CSR creating certificate
2020/06/29 01:37:25 CSR POST /auth
2020/06/29 01:37:25 Service Discovery Started
2020/06/29 01:37:25 Discoverd serive:
2020/06/29 01:37:25     URN.ID:        producer
2020/06/29 01:37:25     Description:   Video Analytics Service
2020/06/29 01:37:25     EndpointURI:   http://analytics-gstreamer:8080
2020/06/29 01:37:25 Starting POST Request:http://analytics-gstreamer:8080/pipelines/emotion_recognition/1
2020/06/29 01:37:25 Pipeline Instance Created: 1

2020/06/29 01:37:25 {
  "avg_fps": 0,
  "elapsed_time": 0.005330085754394531,
  "id": 1,
  "start_time": 1593394645.8940227,
  "state": "QUEUED"
}

2020/06/29 01:37:35 {
  "avg_fps": 133.54638124371084,
  "elapsed_time": 8.90360951423645,
  "id": 1,
  "start_time": 1593394645.8940227,
  "state": "COMPLETED"
}
```

