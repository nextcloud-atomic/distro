#!/bin/bash
set -eux

image="${1?Missing parameter: image}"
image="mkosi.output/${image#mkosi.output/}"
image_name="${image%.tar.*}"
image_name="${image_name%.incus}"
image_name="$(echo -n "mkosi/${image_name#mkosi.output/}" | tr -c "[:alnum:]-/" '-')"
container="$(echo -n "${image_name#mkosi/}" | tr -c "[:alnum:]-" "-")"

if incus image show "${image_name}" > /dev/null 2>&1
then
  incus image delete "${image_name}"
fi

incus image import --alias "$image_name" "$image"

#storage_pool="$(incus storage list -c n -f csv | head -n 1)"

#if ! incus storage volume show "$storage_pool" "${image_name}_persist" > /dev/null 2>&1
#then
#  incus storage volume create "$storage_pool" "${image_name}_persist"
#fi

if incus info "$container" > /dev/null 2>&1; then
  incus stop "$container" || :
  incus rm -f "$container" || :
fi

incus create "$image_name" "$container" -c security.nesting=true -c sysctl.vm_overcommit_memory=1 -c "environment.CREDENTIALS_DIRECTORY=/run/host/credentials" # --profile default

#network="$(incus network list -c 'm,u,n' -f 'json' | jq -r ".[] | select(.managed==true) | select(.used_by[] | contains(\"/1.0/instances/${container}\")) | .name")"

#incus network forward create "$network" 127.0.0.1:
incus config device add "${container}" port-80 proxy listen=tcp:127.0.0.1:80 connect=tcp:127.0.0.1:80
incus config device add "${container}" port-443 proxy listen=tcp:127.0.0.1:443 connect=tcp:127.0.0.1:443

#if [[ -d "${PWD}/${image%.tar.*}.credentials" ]]
#then
#  incus config device add "${container}" "${container}-credentials" disk source="${PWD}/${image%.tar.*}.credentials" path=/credentials readonly=true shift=true
#fi

incus start "${container}"

incus file create -p --type=symlink "${container}/run/host/credentials" /credentials

echo "Incus container started as ${container}"

