#!/usr/bin/bash

set -e

export DATABASE_PASSWORD="$(base64 < /dev/urandom | head -c 32)"
export FULLTEXTSEARCH_PASSWORD="$(base64 < /dev/urandom | head -c 32)"
export NC_DOMAIN="nextcloudatomic.local"
export NEXTCLOUD_PASSWORD="$(base64 < /dev/urandom | head -c 32)"
export ONLYOFFICE_SECRET="$(base64 < /dev/urandom | head -c 32)"
export RECORDING_SECRET="$(base64 < /dev/urandom | head -c 32)"
export REDIS_PASSWORD="$(base64 < /dev/urandom | head -c 32)"
export SIGNALING_SECRET="$(base64 < /dev/urandom | head -c 32)"
export TALK_INTERNAL_SECRET="$(base64 < /dev/urandom | head -c 32)"
export TURN_SECRET="$(base64 < /dev/urandom | head -c 32)"

echo "Installing nc-all-in-one..."
sed \
  -e "s|\${DATABASE_PASSWORD}|${DATABASE_PASSWORD}|" \
  -e "s|\${FULLTEXTSEARCH_PASSWORD}|${FULLTEXTSEARCH_PASSWORD}|" \
  -e "s|\${NC_DOMAIN}|${NC_DOMAIN}|" \
  -e "s|\${NEXTCLOUD_PASSWORD}|${NEXTCLOUD_PASSWORD}|" \
  -e "s|\${ONLYOFFICE_SECRET}|${ONLYOFFICE_SECRET}|" \
  -e "s|\${RECORDING_SECRET}|${RECORDING_SECRET}|" \
  -e "s|\${REDIS_PASSWORD}|${REDIS_PASSWORD}|" \
  -e "s|\${SIGNALING_SECRET}|${SIGNALING_SECRET}|" \
  -e "s|\${TALK_INTERNAL_SECRET}|${TALK_INTERNAL_SECRET}|" \
  -e "s|\${TURN_SECRET}|${TURN_SECRET}|" \
  /usr/lib/ncatomic/nextcloud-aio/defaults.env > /etc/ncatomic/nextcloud-aio/.env
chmod 0600 /etc/ncatomic/nextcloud-aio/.env
echo "Done."
