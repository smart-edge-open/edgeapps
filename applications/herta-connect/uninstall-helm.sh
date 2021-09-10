#! /bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2021 Herta Security

echo "Starting uninstall of Helm Chart for Herta Connect."

helm uninstall hc-openness && echo "Herta Connect uninstalled successfully."


