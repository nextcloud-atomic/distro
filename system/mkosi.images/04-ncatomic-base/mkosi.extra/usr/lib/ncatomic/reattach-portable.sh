#!/usr/bin/bash

lnk="/var/lib/portables/${1?}.raw"
if [[ -f "$lnk" ]] && /usr/bin/portablectl is-attached "$lnk" | /usr/bin/grep -q -e 'attached' -e 'running'
then
  target="$(/usr/bin/readlink -f "$lnk")"
  if ! /usr/bin/grep -q "RootImage=$target" /etc/systemd/system.attached/"${1}".service.d/20-portable.conf
  then
    profile_args=()
    if [[ -d "/usr/lib/systemd/portable/profile/${1}" ]] || [[ -L "/usr/lib/systemd/portable/profile/${1}" ]]
    then
      profile_args=(--profile "$1")
    fi
    /usr/bin/portablectl reattach --enable --now "${profile_args[@]}" "${1}"
  fi
fi
