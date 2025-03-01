#!/usr/bin/bash

set -eu
set +o pipefail

DATABASE_PASSWORD="$(base64 </dev/urandom | tr -d '/' | head -c 20)"          # TODO! This needs to be a unique and good password!
FULLTEXTSEARCH_PASSWORD="$(base64 </dev/urandom | tr -d '/' | head -c 20)"          # TODO! This needs to be a unique and good password!
IMAGINARY_SECRET="$(base64 </dev/urandom | tr -d '/' | head -c 20)"          # TODO! This needs to be a unique and good password!
ONLYOFFICE_SECRET="$(base64 </dev/urandom | tr -d '/' | head -c 20)"          # TODO! This needs to be a unique and good password!
RECORDING_SECRET="$(base64 </dev/urandom | tr -d '/' | head -c 20)"          # TODO! This needs to be a unique and good password!
REDIS_PASSWORD="$(base64 </dev/urandom | tr -d '/' | head -c 20)"          # TODO! This needs to be a unique and good password!
SIGNALING_SECRET="$(base64 </dev/urandom | tr -d '/' | head -c 20)"          # TODO! This needs to be a unique and good password!
TALK_INTERNAL_SECRET="$(base64 </dev/urandom | tr -d '/' | head -c 20)"          # TODO! This needs to be a unique and good password!
TURN_SECRET="$(base64 </dev/urandom | tr -d '/' | head -c 20)"          # TODO! This needs to be a unique and good password!
WHITEBOARD_SECRET="$(base64 </dev/urandom | tr -d '/' | head -c 20)"          # TODO! This needs to be a unique and good password!


for var in DATABASE_PASSWORD FULLTEXTSEARCH_PASSWORD IMAGINARY_SECRET ONLYOFFICE_SECRET RECORDING_SECRET REDIS_PASSWORD SIGNALING_SECRET TALK_INTERNAL_SECRET TURN_SECRET WHITEBOARD_SECRET
do
  [[ "${!var}" != "" ]] || exit 1
done

export DATABASE_PASSWORD FULLTEXTSEARCH_PASSWORD IMAGINARY_SECRET ONLYOFFICE_SECRET RECORDING_SECRET REDIS_PASSWORD SIGNALING_SECRET TALK_INTERNAL_SECRET TURN_SECRET WHITEBOARD_SECRET
