#!/usr/bin/env bash

set -e
sudo rm -rf "skiffos/workspaces/${SKIFF_WORKSPACE}/"
make configure compile cmd/virt/incus/buildimage
incus rm -f skiff && incus storage volume delete default skiff-persist
make cmd/virt/incus/run
