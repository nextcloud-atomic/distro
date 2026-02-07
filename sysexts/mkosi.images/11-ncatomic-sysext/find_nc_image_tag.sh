#!/usr/bin/env bash

set -eu

gh_releases="$(curl -sL \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  'https://api.github.com/repos/nextcloud/all-in-one/releases?per_page=50' \
  | jq -r '.[].tag_name' \
  | grep -P '^v[0-9]+.[0-9]+.[0-9]+$')"
found="no"
for gh_tag in $gh_releases
do
  if [[ "$found" == "yes" ]]
  then
    previous_tag="$gh_tag"
    break
  fi
  if [[ "$gh_tag" == "$AIO_VERSION" ]]
  then
    found=yes
    continue
  fi
  next_tag="$gh_tag"
done

echo "found releases: ${previous_tag:-none} -> <${AIO_VERSION}> -> ${next_tag:-none}" >&2

fetch_release_dates() {
  if [[ -z "${1:-}" ]]
  then
    echo "${2?} ${2?}"
    return
  fi

  local gh_release updated_ts created_ts
  gh_release="$(curl -sL \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "https://api.github.com/repos/nextcloud/all-in-one/releases/tags/${1?}")"
  updated_ts="$(jq -r '.updated_at' <<<"$gh_release")"
  created_ts="$(jq -r '.created_at' <<<"$gh_release")"
  echo "$(date -d "$updated_ts" +%s) $(date -d "$created_ts" +%s)"
}

read -r _ created <<<"$(fetch_release_dates "${AIO_VERSION}")"

read -r prev_updated _ <<<"$(fetch_release_dates "${previous_tag:-}" 0)"

read -r _ next_created <<<"$(fetch_release_dates "${next_tag:-}" "$(date +%s)")"

while read -r tag
do
  # Only consider tags in format YYYYMMDD_HHMMSS
  [[ "$tag" =~ ^[0-9]{8}_[0-9]{6}$ ]] || continue
  tag_time="$(date -d "${tag:0:4}-${tag:4:2}-${tag:6:2}T${tag:9:2}:${tag:11:2}:${tag:13:2}Z" +%s)"

  [[ $(( next_created - tag_time )) -ge 0 ]] || continue # next release version must be created after the image tag
  [[ $(( tag_time - created)) -ge "-$((12*3600))" ]] || continue # image tag must not be created more than 12 hours before the requested release version
  [[ $(( tag_time - prev_updated )) -ge 0 ]] || continue # image tag must be created after the previous release version

  echo "$tag"
  exit 0
done < <(skopeo list-tags --override-arch x86_64 docker://ghcr.io/nextcloud-releases/aio-notify-push | jq -r '.Tags.[]')

set +x
echo "ERROR: No image tag found for release ${AIO_VERSION}!" >&2
exit 1
