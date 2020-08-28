# Optimize the OpenNESS with K8s Benchmark APP for CPU and HDDL-R mode

use k8s configMap to store all the parameters passed to `benchmark_app` command which is in the `do_benchmark.sh` shell script file.

### The details are as follows:

1. First, create a configMap named `cm-benchmark` defining a file containing all environment variables for the `benchmark_app` command executed in `docker` container.\

   ```yaml
   ---
   apiVersion: v1
   kind: ConfigMap
   metadata:
     name: cm-benchmark
   data:
     env.txt: |
       NIREQ=32
       NITER=50000
       # target_device:  CPU, GPU, FPGA, HDDL or MYRIAD are acceptable
       TARGET_DEVICE=CPU
       IMAGE=/opt/intel/openvino/deployment_tools/demo/car.png
       MODEL=/root/openvino_models/ir/public/squeezenet1.1/FP16/squeezenet1.1.xml
       # API: sync/async
       API=async
       BATCH_SIZE=1
   ---
   ```

Insert the configMap content to the top of `benchmark_job.yaml` file.

2. modify the `benchmark_job.yaml` file, add a item to `volumeMounts` and `volumes` fields respectively and add a `--env-file` option to docker run command at args field.

   ```yaml
   ... ...
             args: ["-c", "/usr/local/bin/docker run --rm --device-cgroup-rule='c 10:* rmw' --device-cgroup-rule='c 89:* rmw' --device-cgroup-rule='c 189:* rmw' --device-cgroup-rule='c 180:* rmw' -v /dev:/dev -v /var/tmp:/var/tmp --env-file /dockerenv/env.txt openvino-benchmark:1.0 /do_benchmark.sh"]
   ... ...       
             volumeMounts:
                 - name: dockerenv
                   mountPath: /dockerenv
   ... ... 
          volumes:
             - name: dockerenv
               configMap:
                 name: cm-benchmark
   ```

3. Edit the `do_benchmark.sh` file and replace the parameter by environment variables defined at step 1.

   ```sh
   ... ...
   ./demo_squeezenet_download_convert_run.sh -d ${TARGET_DEVICE}
   
   /root/inference_engine_samples_build/intel64/Release/benchmark_app -i ${IMAGE} -m ${MODEL} -d ${TARGET_DEVICE} -nireq ${NIREQ} -niter ${NITER} -api ${API} -b ${BATCH_SIZE}
   ```

   

