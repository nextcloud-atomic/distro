#!/usr/bin/env bash

set -e
sudo killall qemu-system || true
#sudo rm -rf skiffos/workspaces/qemu/...
make configure compile
#make cmd/virt/docker/buildimage
make cmd/virt/qemu/run
