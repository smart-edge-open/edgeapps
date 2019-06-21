```text
SPDX-License-Identifier: Apache-2.0
Copyright © 2019 Intel Corporation and Smart-Edge.com, Inc.
```
# Purpose
  
  This document  will provide guidelines on how to setup and run openEdge as a consumer application on openNESS based on cloud native infrastructure.

# Running scripts -- build and run openEdgei

On the server that is running openNESS, executed the scripts as blew:

```docker
01_setup.sh

02_build.sh

03_deploy.sh
```

After competition for each script, expected successful print should be
as:

```docker
"msg": "Script completed successfully"
```

Check docker information to make sure that the container STATUS is Up.

```docker
#docker ps

CONTAINER ID IMAGE COMMAND CREATED STATUS PORTS NAMES

f83a63f3f11e composefile_baidu_edge "entrypoint.sh" 4 seconds ago
Up 3 seconds 0.0.0.0:443->443/tcp, 0.0.0.0:1883-1884->1883-1884/tcp
composefile_baidu_edge_1
```

# More details refer to <<openness_baiducloud_application_note>>
