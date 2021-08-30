#!/bin/sh

# this file is largely the default cron shell script for logrotate

THIS=$(basename $0)
cd $(dirname $0)
HERE=$(pwd)

# Configurable values
SAVE_CORES=3
CORE_LOCATION=/fh_vol/fh/logs/cores

# Clean non existent log file entries from status file
test -e status || touch status
head -1 status > status.clean
sed 's/"//g' status | while read logfile date
do
    [ -e "$logfile" ] && echo "\"$logfile\" $date"
done >> status.clean
mv status.clean status

# logrotate requires go-w; let's force it to be sure it never breaks
chmod 640 fh-log-rotate

if test -x /usr/sbin/logrotate; then
    echo $(date -Iseconds) $THIS: running /usr/bin/logrotate fh-log-rotate
    /usr/sbin/logrotate fh-log-rotate -s ./status
else
    echo $THIS: ERROR: /usr/bin/logrotate does not exist.
fi

if test -d /fh_vol/fh/logs/cores; then
    echo $(date -Iseconds) $THIS: removing core files from $CORE_LOCATION to not greater than $SAVE_CORES
    ls -dA1t $CORE_LOCATION/* | tail -n +$(($SAVE_CORES + 1)) | xargs rm -f
fi

