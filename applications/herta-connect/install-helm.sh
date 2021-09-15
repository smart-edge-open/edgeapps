#! /bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2021 Herta Security

echo "Starting install of Helm Chart for Herta Connect."

helm install hc-openness helm/hc-openness && echo "Herta Connect installed successfully."


