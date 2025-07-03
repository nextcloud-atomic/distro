#!/usr/bin/bash

ssh \
  -i /var/home/tknoeppl/projects/private/ncatomic/distro/mkosi.key \
  -F none \
  -o UserKnownHostsFile=/dev/null \
  -o StrictHostKeyChecking=no \
  -o LogLevel=ERROR \
  -o ProxyCommand="socat - VSOCK-CONNECT:1110324147:%p" \
  -L 127.0.0.1:80:127.0.0.1:80 \
  -L 127.0.0.1:443:127.0.0.1:443 \
  root@mkosi

