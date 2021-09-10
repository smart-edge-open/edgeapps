#! /bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2021 Herta Security

file=custom-config.sh

if test -f "${file}"; then
    bash ${file} && "Herta Connect successfully configured."
else
    echo "Please contact your Herta representative to obtain your customised configuration script."
fi


