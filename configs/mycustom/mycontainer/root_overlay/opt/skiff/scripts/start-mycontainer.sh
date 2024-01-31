#!/bin/bash
set -eo pipefail

# container image
IMAGE=library/redis:latest
# container name
CONTAINER=mycontainer

echo "Probing tun..."
modprobe tun || true

echo "Checking for image..."
if ! docker inspect ${IMAGE}; then
    if [ -f /mnt/rootfs/resources/images/${IMAGE}.tar.gz ]; then
        echo "Loading image from resources..."
        cat /mnt/rootfs/resources/images/${IMAGE}.tar.gz |\
            gzip -d |\
            docker load
    else
        echo "Image ${IMAGE} does not exist in resources, pulling..."
        docker pull ${IMAGE}
    fi
fi

echo "Checking for container..."
if ! docker inspect ${CONTAINER} > /dev/null ; then
    echo "Creating container..."
    docker run -d \
           --name=${CONTAINER} \
           --restart=always \
           --privileged \
           --net=host \
           --dns="1.1.1.1" \
           --dns="8.8.8.8" \
           -v /dev:/dev \
           -v /lib/modules:/lib/modules:ro \
           -v /mnt/persist/data:/var/lib/mydata \
           ${IMAGE}
else
    echo "Container already running."
fi
