#!/usr/bin/bash

set -eu
set +o pipefail

DATABASE_PASSWORD="$(openssl rand -hex 24 2>/dev/null | head -c 20)"
FULLTEXTSEARCH_PASSWORD="$(openssl rand -hex 24 2>/dev/null | head -c 20)"
IMAGINARY_SECRET="$(openssl rand -hex 24 2>/dev/null | head -c 20)"
ONLYOFFICE_SECRET="$(openssl rand -hex 24 2>/dev/null | head -c 20)"
RECORDING_SECRET="$(openssl rand -hex 24 2>/dev/null | head -c 20)"
REDIS_PASSWORD="$(openssl rand -hex 24 2>/dev/null | head -c 20)"
SIGNALING_SECRET="$(openssl rand -hex 24 2>/dev/null | head -c 20)"
TALK_INTERNAL_SECRET="$(openssl rand -hex 24 2>/dev/null | head -c 20)"
TURN_SECRET="$(openssl rand -hex 24 2>/dev/null | head -c 20)"
WHITEBOARD_SECRET="$(openssl rand -hex 24 2>/dev/null | head -c 20)"


for var in DATABASE_PASSWORD FULLTEXTSEARCH_PASSWORD IMAGINARY_SECRET ONLYOFFICE_SECRET RECORDING_SECRET REDIS_PASSWORD SIGNALING_SECRET TALK_INTERNAL_SECRET TURN_SECRET WHITEBOARD_SECRET
do
  [[ "${!var}" != "" ]] || exit 1
done

export DATABASE_PASSWORD FULLTEXTSEARCH_PASSWORD IMAGINARY_SECRET ONLYOFFICE_SECRET RECORDING_SECRET REDIS_PASSWORD SIGNALING_SECRET TALK_INTERNAL_SECRET TURN_SECRET WHITEBOARD_SECRET
