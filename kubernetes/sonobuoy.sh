#!/usr/bin/env bash

source <(curl -s https://raw.githubusercontent.com/d47zm3/bash-framework/master/bash.sh)

github_project="vmware-tanzu/sonobuoy"
github_project_short="$( basename ${github_project})"
download_filename="sonobuoy.tar.gz"

download_sonobuoy() {
  latest_tag=$( curl --silent "https://api.github.com/repos/${github_project}/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")' )
  latest_tag_raw=$( echo "${latest_tag}" | grep -E -o "[0-9\.]+" )
  link="https://github.com/${github_project}/releases/download/${latest_tag}/${github_project_short}_${latest_tag_raw}_linux_amd64.tar.gz"
  curl -s -L -o "${download_filename}" "${link}"
  tar xzf "${download_filename}" -C /usr/local/bin/
  rm -f "${download_filename}"
}

help_sonobuoy() {
  decho ">>> to run quick test:"
  decho "sonobuoy run --wait --mode quick"
  decho ">>> to run normal test:"
  decho "sonobuoy run --wait"
  decho ">>> to print results:"
  decho "sonobuoy results \$( sonobuoy retrieve )"
  decho "to cleanup:"
  decho "sonobuoy delete --wait"
}

if ! command_exists sonobuoy
then
  decho "installing ${github_project}"
  download_sonobuoy
else
  current_version=$( sonobuoy version | grep -i "sonobuoy" | awk ' { print $NF } ' )
  latest_tag=$( curl --silent "https://api.github.com/repos/${github_project}/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")' )
  if [[ "${current_version}" != "${latest_tag}" ]]
  then
    decho "updating ${github_project}"
    rm -f /usr/local/bin/${github_project_short}
    download_sonobuoy
  else
    decho "${github_project} is in current version!"
  fi
fi

help_sonobuoy
