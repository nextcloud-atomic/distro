#!/usr/bin/env bash

set -e
docker stop skiff && docker rm skiff || true
sudo rm -rf skiffos/workspaces/virt/docker-run/docker-persist
make compile
make cmd/virt/docker/buildimage
make cmd/virt/docker/run
