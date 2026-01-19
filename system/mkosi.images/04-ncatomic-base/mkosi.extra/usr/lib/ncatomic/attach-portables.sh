#!/usr/bin/bash


exit 0



if ! [[ -f "${PORTABLES_PATH?}/base" ]]
then
  echo "ERROR: Base image (${PORTABLES_PATH}/base) not found!"
  exit 1
fi

base_img="$(readlink -f "${PORTABLES_PATH}/base")"
restart_ncatomic=false
for f in "${PORTABLES_PATH}/"*
do
  [[ -L "$f" ]] || continue
  [[ "$f" != "${PORTABLES_PATH}/base" ]] || continue

  img="$(readlink -f "$f")"; \
  systemd-dissect --validate "$img" || {
    echo "ERROR: Validation failed for $img"
    continue
  }
  img_args=("${base_img}" "--extension=${img}")
  if [[ "${f}" =~ ^.*"-standalone" ]]
  then
    img_args=("${img}")
  fi

  if portablectl is-attached | grep "detached"
  then
    echo "Attaching $img"
    portablectl attach -p trusted --enable "${img_args[@]}"
  else
    echo "Reattaching $img"
    portablectl reattach -p trusted --enable "${img_args[@]}"
    restart_ncatomic=true
  fi
done

[[ "$restart_ncatomic" == "false" ]] || systemctl restart ncatomic.target