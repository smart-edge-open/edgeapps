#!/bin/bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

if [[ "${#}" -ne 2 ]]; then
  echo "Wrong arguments. Usage: ${0} <ansible_host_ssh_address> <eis_images_version>"
  exit 1
fi

ansible_host_ssh_address=$1
eis_version=$2
images_to_import=(
  "ia_camera_stream:${eis_version}"
  "ia_etcd:${eis_version}"
  "ia_video_ingestion:${eis_version}"
  "ia_video_analytics:${eis_version}"
  "ia_visualizer:${eis_version}"
  "ia_web_visualizer:${eis_version}"
)

export_docker_image () {
 # $1 - Docker image repository and tag
  echo "Exporting image ${1}..."
  
  # shellcheck disable=SC2029
  # variable ${1} is expected to be expanded on the client side
  ssh "${ansible_host_ssh_address}" "if [ ! -f /tmp/eis_images_export/${1}.tar ]; then docker save -o /tmp/eis_images_export/${1}.tar ${1}; fi"
  if [[ $? -ne 0 ]]; then
    echo "ERROR: Could not export image ${1}."
    exit 1
  fi
  echo "Exporting completed"
}

download_docker_image () {
# $1 - Docker image repository and tag
  echo "Downloading image ${1}..."
  if [[ ! -f "/tmp/eis_images_import/${1}.tar" ]]; then
    scp "${ansible_host_ssh_address}:/tmp/eis_images_export/${1}.tar" "/tmp/eis_images_import/"
    if [[ $? -ne 0 ]]; then
      echo "ERROR: Could not download image ${1}."
      exit 1
    fi
    echo "Downloading completed"
  else
    echo "File /tmp/eis_images_import/${1} already exists, skipping..."
  fi
}

import_docker_image () {
# $1 - Docker image repository and tag
  echo "Importing image ${1}..."
  docker load -i "/tmp/eis_images_import/${1}.tar"
  if [[ $? -ne 0 ]]; then
    echo "ERROR: Could not import image ${1}."
    exit 1
  fi
  echo "Importing completed"
}

# Check root permissions
id -u 1>/dev/null
if [[ $? -ne 0 ]]; then
  echo "ERROR: Script requires root permissions"
  exit 1
fi

echo "Check if ssh connection is setup using ssh-keys"
ssh -o BatchMode=yes "${ansible_host_ssh_address}" 'exit'
if [[ ! $? -eq 0 ]]; then
  echo "Connection is not prepared correctly. Please setup ssh connection to the old ansible" \
    "host before running this script."
  exit 1
fi

# Install Docker if missing
command -v docker 1>/dev/null
if [[ $? -ne 0 ]]; then
  echo "Docker not installed..."
  yum install -y yum-utils
  if [[ $? -ne 0 ]]; then
    echo "ERROR: Could not install yum-utils package."
    exit 1
  fi
  yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  if [[ $? -ne 0 ]]; then
    echo "ERROR: Could not add Docker CE repository. Check above for possible root cause"
    exit 1
  fi
  
  echo "Installing docker-ce..."
  yum install -y docker-ce docker-ce-cli containerd.io
  if [[ $? -ne 0 ]]; then
    echo "ERROR: Could not install docker-ce packages"
    exit 1
  fi
fi

echo "Check if docker service is running and start if not"
command systemctl is-active --quiet docker.service
if [[ $? -ne 0 ]]; then
  echo "Docker service is not running, try to start..."
  command systemctl start docker
  if [[ $? -ne 0 ]]; then
    echo "ERROR: Could not start Docker service. Exiting..."
    exit 1
  fi
fi

# Export Docker images on other Ansible host
ssh "${ansible_host_ssh_address}" "if [ ! -d /tmp/eis_images_export ]; then mkdir /tmp/eis_images_export; fi"
if [[ $? -ne 0 ]]; then
  echo "ERROR: Could not create temporary folder /tmp/eis_images_export on remote"
  exit 1
fi
for pod_name in "${images_to_import[@]}"; do
  export_docker_image "${pod_name}"
done

# Download images to the current Ansible host
if [[ ! -d "/tmp/eis_images_import" ]]; then
  mkdir /tmp/eis_images_import
  if [[ $? -ne 0 ]]; then
    echo "ERROR: Could not create temporary folder /tmp/eis_images_import"
    exit 1
  fi
fi
for pod_name in "${images_to_import[@]}"; do
  download_docker_image "${pod_name}"
done

# Import Docker images on the current Ansible host
for pod_name in "${images_to_import[@]}"; do
  import_docker_image "${pod_name}"
done
