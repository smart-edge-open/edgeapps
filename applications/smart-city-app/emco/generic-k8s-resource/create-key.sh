#!/bin/bash -e
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

case "$(cat < /proc/1/sched | head -n 1)" in
*create-key.sh*)  # in docker
    rm -rf /home/.ssh && mkdir -p /home/.ssh && chmod 700 /home/.ssh

    # create key pair for ssh to cloud db host machine
    if [ ! -f /home/.key/id_rsa ]; then
        rm -rf "/home/.key" && mkdir -p "/home/.key" && chmod 700 /home/.key
        ssh-keygen -f /home/.key/id_rsa -N "" -q
    fi

    # copy keys to cloud db host machine
    ssh-copy-id -o CheckHostIP=yes -o StrictHostKeyChecking=ask -o UserKnownHostsFile=/home/.ssh/known_hosts -i /home/.key/id_rsa "$1"
    ;;
*)
    IMAGE="$2smartcity/smtc_web_cloud_tunnelled"
    DIR=$(dirname "$(readlink -f "$0")")
    OPTIONS=(-v "$DIR:/home:rw")
    echo "$IMAGE" >/dev/null
    echo "${OPTIONS[@]}" >/dev/null
    . "/opt/openness/smart_secret/shell.sh" /home/create-key.sh "$1"
    ;;
esac
