#!/bin/bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

usage() { echo "Usage: $0 [-s <Full path to the release package archive file>] [-d <Full destination path having zip file name>]" 1>&2; exit 1; }

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

tempdir="/tmp/eispatch"
release_source_path=${s}
release_destination_path=${d}

# Create temp directory if not exist
if [ ! -d "$tempdir" ]
then
    echo "Directory doesn't exist. Creating now"
    mkdir $tempdir
fi

# Extract release package to apply patch
tar xvzf "$release_source_path" -C "$tempdir"

# Save current working directory to get patch file path and move to release source path
cwd=$(pwd)
package_dir=($tempdir/*)
bdir=$(basename "${package_dir[0]}")
sources_dir="$tempdir/$bdir/IEdgeInsights"
cd "$sources_dir"

# Apply patch
patch -ruN -p1 < "$cwd"/eis_diff_patch.patch

# Zip the folder after applying patch
cd $tempdir
tar zcvf "$release_destination_path" "$bdir"

# Remove temporary diretory
rm -rf $tempdir
