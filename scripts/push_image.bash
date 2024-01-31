#!/bin/bash
set -eo pipefail

SKIFF_ROOT=${SKIFF_ROOT:-./skiffos}
if [ ! -d ${SKIFF_ROOT} ]; then
    echo "please run from the root dir ${SKIFF_ROOT} - ./scripts/push_image.bash"
    exit 1
fi

export SKIFF_ROOT
${SKIFF_ROOT}/scripts/push_image.bash $@
