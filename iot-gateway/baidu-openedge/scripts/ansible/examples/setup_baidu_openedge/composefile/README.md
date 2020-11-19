```text
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2019 Intel Corporation
```

# This directory contains scripts for docker-composer file and related Dockerfile to build baiduEdge container.

- The sub-directory democfg should put certification and configuration files downloaded from baidu cloud when creating baidu edge services. If these files exist, please open the comments below in the Dockerfile
```bash
#COPY ./democfg/application.yml /usr/local/var/db/openedge/application.yml
#COPY ./democfg/agent-conf/service.yml /usr/local/var/db/openedge/agent-conf/service.yml
#COPY ./democfg/agent-cert/*.* /usr/local/var/db/openedge/agent-cert/
#COPY ./democfg/remote-iothub-conf/service.yml /usr/local/var/db/openedge/remote-iothub-conf/service.yml
```

- The files list refers to Readme in the democfg folder. 

- precheck.sh is used for check whether all the required certification and configuraiton files exist in the democfg directory.
