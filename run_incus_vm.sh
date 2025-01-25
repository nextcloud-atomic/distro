#!/bin/bash

set -eux

incus delete -f ncatomic-test || :;
incus image delete mkosi/ncatomic-vm || :;
trap 'rm "${qcow_path}"' EXIT
qcow_path="$(mktemp -d)/os-image.qcow2"
qemu-img convert -f raw -O qcow2 $(ls mkosi.output/NextcloudAtomic_*.raw | grep -v usr | grep -v esp | sort | tail -1) "${qcow_path}"
incus image import --alias mkosi/ncatomic-vm test/metadata.tar.xz "${qcow_path}"
incus init --vm mkosi/ncatomic-vm ncatomic-test -c security.secureboot=false -c limits.cpu=4 -c "environment.CREDENTIALS_DIRECTORY=/run/host/credentials" -c limits.memory=8GiB -d root,size=50GiB
incus config device add ncatomic-test vtpm tpm

qemu_credential_args=()
if [[ -d "${PWD}/mkosi.output/NextcloudAtomic_test.incus.credentials" ]]
then
  for f in "${PWD}/mkosi.output/NextcloudAtomic_test.incus.credentials"/*
  do
    cred_key="$(basename "$f")"
    cred_val="$(cat "$f")"
    qemu_credential_args+=(-smbios "\"type=11,value=io.systemd.credential:$cred_key=$cred_val\"")
  done
  incus config set ncatomic-test "raw.qemu=${qemu_credential_args[*]}"
  #incus config device add ncatomic-test ncatomic-test-credentials disk source="${PWD}/mkosi.output/NextcloudAtomic_test.incus.credentials" path=/credentials readonly=true shift=true
fi

incus start ncatomic-test --console

#for i in {1..20}
#do
#  ! incus exec ncatomic-test -- true || break
#  sleep 3
#done

#if [[ -d "${PWD}/mkosi.output/NextcloudAtomic_test.incus.credentials" ]]
#then
#  incus file create -p --type=symlink "ncatomic-test/run/host/credentials" /credentials
#fi

#incus file push -p mkosi.crt ncatomic-test/etc/verity.d/mkosi.crt
#incus file push -p mkosi.output/debug.raw ncatomic-test/var/lib/extensions/debug.raw
#incus file push mkosi.output/podman.raw ncatomic-test/var/lib/extensions/podman.raw
#incus file push mkosi.output/ncatomic.raw ncatomic-test/var/lib/extensions/ncatomic.raw

#incus console ncatomic-test
#incus exec ncatomic-test -- systemd-sysext list
#incus exec ncatomic-test -- systemd-sysext merge
#incus exec ncatomic-test -- systemctl enable systemd-sysext
#incus restart ncatomic-test
#incus console ncatomic-test

#incus exec ncatomic-test -- mkdir -p /var/lib/extensions
#incus exec ncatomic-test -- systemd-sysext list
#incus exec ncatomic-test -- systemd-sysext list
#incus exec ncatomic-test -- systemd-sysext merge
#incus exec ncatomic-test -- systemd-sysusers
