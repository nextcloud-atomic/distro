#!/usr/bin/bash

for lnk in /var/lib/portables/*.raw;
do
  if /usr/bin/portablectl is-attached "$lnk" | /usr/bin/grep -q 'attached'
  then
    svc_name="$(/usr/bin/basename "$lnk" .raw)"
    target="$(/usr/bin/readlink -f "$lnk")"
    if ! /usr/bin/grep -q "RootImage=$target" /etc/systemd/system.attached/"${svc_name}".service.d/20-portable.conf
    then
      /usr/bin/portablectl reattach --enable --now "${svc_name}"
    fi
  fi
done