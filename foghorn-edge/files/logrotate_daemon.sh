#!/bin/sh

# assume the following file exists, i.e., when run in a docker image, proper
# mounts exists:
#     $LOGROTATE: see variable below

# docker stops containers with TERM so make sure we respond to it nicely
trap exit TERM

THIS=$(basename $0)
HERE=$(dirname $0)
cd $HERE

LOGROTATE=/fh_vol/fh/assets/logrotate/logrotate.sh

PERIOD_S=$((60*60)) # hourly

main() {
    while [ 1 -eq 1 ]; do
        $LOGROTATE
        sleep $PERIOD_S &
        wait $!
    done
}

main

