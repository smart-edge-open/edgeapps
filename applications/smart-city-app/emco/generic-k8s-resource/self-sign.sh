#!/bin/bash -e
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

DIR="$(dirname "$(readlink -f "$0")")"
USER="docker"

case "$(cat < /proc/1/sched | head -n 1)" in
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
    IMAGE="$1smtc_certificate"
    OPTIONS=("--volume=$DIR:/home/$USER:rw")
    echo "$IMAGE" >/dev/null
    echo "${OPTIONS[@]}" >/dev/null
    . "/opt/openness/smart_secret/shell.sh" /home/$USER/self-sign.sh "$(hostname -f)" 
    ;;
esac
