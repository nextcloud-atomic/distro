#!/usr/bin/bash

set -eu

print_usage() {
  echo "Usage:
  $(basename "$0") [machine-name | path-to-mkosi-conf | path-to-machine.json]"
}

if [[ " $* " =~ (" --help "|" -h ") ]]
then
  print_usage
  exit 0
fi

if [[ -z "${1:-}" ]] || [[ "$1" =~ ".conf"$ ]]
then
  mkosi_conf="${1:-mkosi.conf}"
  if ! [[ -f "$mkosi_conf" ]]
  then
    echo "Could not read image id from '$mkosi_conf': no such file" $'\n'
    print_usage
    exit 1
  fi
  vm_name="$(grep '^ImageId=' "${1:-mkosi.conf}" || true)"
  vm_name="${vm_name#ImageId=}"
  if [[ -z "${vm_name:-}" ]]
  then
    echo "Could not determine machine name." $'\n'
    print_usage
    exit 1
  fi
elif [[ -f "$1" ]] && [[ "$1" =~ ".json"$ ]]
then
    machine_json="$1"
else
  vm_name="$1"
fi

if [[ -z "${machine_json:-}" ]]
then
  machine_json="$XDG_RUNTIME_DIR/mkosi/machine/${vm_name}.json"
fi

if ! [[ -f "$machine_json" ]]
then
  echo "Could not find a machine config file at '$machine_json'." $'\n'
  print_usage
  exit 1
fi

proxy_command="$(jq -r '.ProxyCommand' "$machine_json")"
ssh_key="$(jq -r '.SshKey' "$machine_json")"

ssh \
  -i "${ssh_key?}" \
  -F none \
  -o UserKnownHostsFile=/dev/null \
  -o StrictHostKeyChecking=no \
  -o LogLevel=ERROR \
  -o ProxyCommand="${proxy_command?}" \
  -L 127.0.0.1:80:127.0.0.1:80 \
  -L 127.0.0.1:443:127.0.0.1:443 \
  root@mkosi

