#!/bin/bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

IMAGE="ovc_self_certificate"
DIR=$(dirname $(readlink -f "$0"))
USER="docker"

case "$(cat /proc/1/sched | head -n 1)" in
*self-sign*)
    openssl req -x509 -nodes -days 30 -newkey rsa:4096 -keyout /home/$USER/self.key -out /home/$USER/self.crt << EOL
US
OR
Portland
Oregon
Data Center Group
Intel Corporation
$1
nobody@intel.com
EOL
    chmod 640 "/home/$USER/self.key"
    chmod 644 "/home/$USER/self.crt"
    ;;
*)
    OPTIONS=("--volume=$DIR:/home/$USER:rw")
    pid="$(docker ps -f ancestor=$IMAGE --format='{{.ID}}' | head -n 1)"
    if [ -n "$pid" ] && [ "$#" -le "1" ]; then
        echo "bash into running container...$IMAGE"
        docker exec -it $pid ${*-/bin/bash}
    else
        echo "bash into new container...$IMAGE"
        args=("$@")
        docker run --rm ${OPTIONS[@]} $(env | cut -f1 -d= | grep -E '_(proxy|REPO|VER)$' | sed 's/^/-e /') --entrypoint /home/$USER/self-sign.sh -it "${IMAGE}" "$(hostname -f)"
    fi
    ;;
esac

