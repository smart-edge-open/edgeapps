```
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2020 Intel Corporation
```

# OpenVINO Benchmark Performance Test

> Notes: The following all steps assumes that OpenNESS were installed through [OpenNESS playbooks](https://github.com/smart-edge-open/specs/blob/master/doc/getting-started/openness-cluster-setup.md).

- [Precondition](#precondition)
- [Build benchamrk image](#build-benchamrk-image)
- [Deploy](#deploy)
- [Troubleshooting](#troubleshooting)

### Precondition

1. **configuration preparation**

   edit `benchmark_job.yaml` file and modify the `data` field in `configMap` section. All the following environment variables is used by `benchmark_app` command.

   ```yaml
   ... ...
       NIREQ=32
       NITER=50000
       # target_device:  CPU, GPU, FPGA, HDDL or MYRIAD are acceptable
       TARGET_DEVICE=CPU
       IMAGE=/opt/intel/openvino/deployment_tools/demo/car.png
       MODEL=/root/openvino_models/ir/public/squeezenet1.1/FP16/squeezenet1.1.xml
       # API: sync/async
       API=async
       BATCH_SIZE=1
   ... ...
   ```

### Build benchamrk image

1. Download edgeapp on both controller and node machine, go to dir edgeapps/applications/openvino/benchmark/

2.  Build benchmark on node by:

   ```
   sh build_image.sh
   ```

3.  change `parallelism: 1` to pod number in `benchmark_job.yaml` file on controller machine.

### Deploy

1. Query which jobs are currently running.

   ```
   kubectl get jobs
   ```

   If a job named `openvino-benchmark-job` in k8s cluster is exist, delete it.

   ```
   kubectl delete jobs openvino-benchmark-job
   ```

2.  On controller machine execute following command to start the job and get logs of each pod

   ```
   kubectl apply -f  benchmark_job.yaml
   ```

3.  After `openvino-benchmark-job` job launched in step 2 is completed, on node `docker ps`  and `docker logs` to get all deamon log

### Troubleshooting

In this section some issues in implementation process are covered

1. Benchmark image build failed. When `sh build_image.sh` on node, interrupted by some errors such as following:

   ```sh
   ... ...
   E: Release file for http://security.ubuntu.com/ubuntu/dists/bionic-security/InRelease is not valid yet (invalid for another 5h 38min 40s). Updates for this repository will not be applied.
   E: Release file for http://archive.ubuntu.com/ubuntu/dists/bionic-updates/InRelease is not valid yet (invalid for another 5h 39min 53s). Updates for this repository will not be applied.
   E: Release file for http://archive.ubuntu.com/ubuntu/dists/bionic-backports/InRelease is not valid yet (invalid for another 5h 41min 27s). Updates for this repository will not be applied.
The command '/bin/sh -c apt-get update && apt-get install -y --no-install-recommends     cpio     sudo     python3-pip     python3-setuptools     libboost-filesystem1.65     libboost-thread1.65     libboost-program-options1.65     lsb-release     libjson-c-dev' returned a non-zero code: 100
   ```

   Invalid time causes the server to be unable to use  Ubuntu’s packaging system apt .

   >  **The solution is to synchronize your clock manually or use a service (the better way)!**

   **Reference:**

    https://ahelpme.com/linux/ubuntu/ubuntu-apt-inrelease-is-not-valid-yet-invalid-for-another-151d-18h-5min-59s/
