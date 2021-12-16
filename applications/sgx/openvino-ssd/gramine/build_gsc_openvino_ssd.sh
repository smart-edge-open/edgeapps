#! /bin/bash

# Copyright 2021 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This is a helper script to build Graminized docker image.
# Execute this script from gramine repo top level Tools/gsc directory.

# Openvino application docker image name.
IMAGE_NAME=openvino-ssd
# Graminized docker image name.
GSC_IMAGE_NAME=gsc-$IMAGE_NAME

# Check if PROJECT_HOME is set. If not exit.
if [ -z "$PROJECT_HOME" ]; then
  echo "PROJECT_HOME is not set. Please set it to openvino-ssd top level directory"
  echo "In the current shell: export PROJECT_HOME=<openvino-ssd directory>"
  exit
else
  echo "PROJECT_HOME is set to $PROJECT_HOME"
fi

# Check if GSC image exists. If so delete it first before building new image.
GSC_IMAGE_EXISTS=$(sudo docker image inspect $GSC_IMAGE_NAME  >/dev/null 2>&1 && echo yes || echo no)
if [ "$GSC_IMAGE_EXISTS" = "yes" ]; then
  echo "Remove existing GSC image"
  sudo docker rmi $GSC_IMAGE_NAME --force
fi

MANIFEST_FILE_DIR="${PROJECT_HOME}/gramine"
MANIFEST_FILE="openvino-ssd.manifest"

echo "Manifest file to be read : ${MANIFEST_FILE_DIR}/${MANIFEST_FILE}"
# Build image.
# "--insecure-args" will allow untrusted arguments to be specified
# during docker run. Please refer GSC documentation for further details.
echo "Build unsigned GSC image"
./gsc build --insecure-args $IMAGE_NAME "${MANIFEST_FILE_DIR}"/"${MANIFEST_FILE}"


# Generate signing key if it doesn't exists
SIGN_KEY_FILE=enclave-key.pem
if [ ! -f "$SIGN_KEY_FILE" ]; then
  openssl genrsa -3 -out $SIGN_KEY_FILE 3072
fi

# Sign image to generate final GSC image
echo "Generate Signed GSC image"
./gsc sign-image $IMAGE_NAME $SIGN_KEY_FILE
