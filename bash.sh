#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

export DEBIAN_FRONTEND=noninteractive

decho() {
  string=$1
  echo "[***] [$( date +'%H:%M:%S' )] ${string}"
}

command_exists() {
  command_name="${1}"
  command -v "${command_name}" &> /dev/null
}

docker_exists() {
  container_name="${1}"
  if [ ! "$(docker ps -aq -f name="${container_name}")" ]; then
    return 1
  else
    return 0
  fi
}

validate_url() {
  if wget -S --spider "${1}" 2>&1 | grep -q 'HTTP/1.1 200 OK'
  then
    return 0
  else
    return 1
  fi
}
