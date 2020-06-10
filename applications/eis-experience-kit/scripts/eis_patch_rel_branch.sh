#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

dirname="/tmp/eispatch"
release_pkg_extract="/tmp/eispatch/release_temp"

usage() { echo "Usage: $0 [-s <source path including zip file>] [-d <Destination path having zip file name>]" 1>&2; exit 1; }

while getopts ":s:d:" o; do
    case "${o}" in
        s)
            s=${OPTARG}
            ;;
        d)
            d=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${s}" ] || [ -z "${d}" ]; then
    usage
fi

release_source_path=${s}
release_destination_path=${d}

#create main directory if not exist
if [ ! -d "$dirname" ]
then
    echo "File doesn't exist. Creating now"
    mkdir $dirname
fi
#create sub directory if not exist
if [ ! -d "$release_pkg_extract" ]
then
    echo "File doesn't exist. Creating now"
    mkdir $release_pkg_extract
fi

#Extract release package to apply patch
tar xvzf $release_source_path -C $release_pkg_extract

#save current working directory to get patch file path and move to release source path
cwd=$(pwd)
cd $release_pkg_extract

#Apply patch 
patch -ruN -p2 < "$cwd"/eis_diff_patch.patch

#zip the folder after applying patch
zip -r $release_destination_path $release_pkg_extract
