#!/usr/bin/env bash

set -e
docker stop skiff && docker rm skiff || true
make compile
make cmd/virt/docker/buildimage
make cmd/virt/docker/run
