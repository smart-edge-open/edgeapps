# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2019 Intel Corporation

#!/bin/bash -xe

docker run --rm --device-cgroup-rule='c 10:* rmw' --device-cgroup-rule='c 89:* rmw' --device-cgroup-rule='c 189:* rmw' --device-cgroup-rule='c 180:* rmw' -v /dev:/dev -v /var/tmp:/var/tmp --name openvino-benchmark --network host -it openvino-benchmark:1.0 /bin/bash


