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
To build sample application container image:

```sh
./build/build-image.sh
```

To deploy and test the sample application:

- Make sure the sample application images built and reachable 
- Two method for the deployment on the openness edge node
  - Use the command ```kubectl apply``` with the yaml file ```vas-cons-app.yaml``` in the folder - deployments/yaml
  - Or use helm charts in the folder - deployments/helm
- Check Results by ```kubectl logs```
