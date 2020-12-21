# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

The following are the steps to bring up the sample application pod with side-car agent container:

1. Build the Docker image for sample metric application and push it to OpenNESS local Harbor Registry
	- `cd image`
	- `./build.sh push <registry_IP> <registry_port>`

2. Create a secret with root CA used to validate against the server (collector) certificates
	- Edit default path to root CA if different from default in create-secret.sh script
	- `./create-secret.sh`

3. Deploy pod using Helm
	- `helm install otel_agent opentelemetry-agent`

