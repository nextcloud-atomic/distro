[group("core")]
fetch-core:
  #!/usr/bin/env bash
  set -ex
  mkdir -p ./src
  [ -d ./src/core ] || git submodule add https://github.com/nextcloud-atomic/core.git ./src/core
  ( cd ./src/core && git pull; )

[group("core")]
mod? nca-core 'src/core/Justfile'

[group("clean")]
[group("core")]
clean-core:
  @just nca-core::clean
  echo "done."

[group("core")]
build-core target='release':
  #!/usr/bin/env bash
  set -ex
  just nca-core::build --docker "{{target}}"
  rm -rf portables/mkosi.images/04-nca-web/nca-web.extra/usr/share/ncatomic/nca-web/public || :;
  cp -r "src/core/out/{{target}}/nca-web/public" portables/mkosi.images/04-nca-web/nca-web.extra/usr/share/ncatomic/nca-web/
  cp    "src/core/out/{{target}}/nca-web/ncatomic-web" portables/mkosi.images/04-nca-web/nca-web.extra/usr/share/ncatomic/nca-web/ncatomic-web
  cp    "src/core/out/{{target}}/"{nca-logs,nca-system,ncatomic,occ,occd} sysexts/mkosi.images/11-ncatomic-sysext/mkosi.extra/usr/bin/

[group("clean")]
clean:
  #!/usr/bin/env bash
  set -ex
  just nca-core::clean || :;
  ! [[ -d mkosi.output ]] || sudo rm -rf ./{system,sysexts,portables}mkosi.output/*
  #sudo rm -rf ./tools/tools

## Build

_parse_build_args:
  #!/usr/bin/env bash

[group("build")]
genkey:
  #!/usr/bin/env bash
  set -euxo pipefail
  [[ -f mkosi.key ]] || mkosi genkey

[group("build")]
[arg("rebuild", long="rebuild", value="true")]
toolstree rebuild="false" *ARGS="":
  #!/usr/bin/env bash
  if ! [[ -d "tools/tools" ]] || [[ "{{rebuild}}" == "true" ]]
  then
    mkosi -C tools build -f
  fi

[group("build")]
build target='release' *ARGS="-i -f":
  just build-system "{{target}}" -- {{ARGS}}

[group("build")]
[arg("noclean", long="no-clean", value="true")]
[arg("nocore", long="no-core", value="true")]
build-portables noclean="false" nocore="false" target='release' *ARGS="-i -f": genkey toolstree
  #!/usr/bin/env bash
  ARGS=({{ARGS}})
  if [[ -z "{{ARGS}}" ]]
  then
    ARGS=("-if")
  fi
  if [[ "{{target}}" == "debug" ]] && ! [[ " {{ARGS}} " =~ " "(-P|--profile)" " ]]
  then
    ARGS+=(--profile debug)
  fi

  if [[ "{{noclean}}" != true ]] && [[ " ${ARGS[*]}" =~ " -"[a-zA-Z0-9]*"f" ]]
  then
    just clean
  fi

  if ! [[ -d "src/core" ]]
  then
    just fetch-core
  fi

  if [[ -d "src/core/out/{{target}}" ]] && [[ "{{nocore}}" != true ]]
  then
    if [[ "{{noclean}}" != true ]] && [[ " ${ARGS[*]}" =~ " -"[a-zA-Z0-9]*"f" ]]
    then
      just clean-core
    fi
    just build-core {{target}}
  fi

  cp mkosi.key mkosi.crt portables/

  echo mkosi "${ARGS[@]}" -C sysexts
  mkosi "${ARGS[@]}" -C sysexts

[group("build")]
[arg("noclean", long="no-clean", value="true")]
build-sysexts noclean="false" target='release' *ARGS="-if": genkey (toolstree)
  #!/usr/bin/env bash
  set -exuo pipefail

  ARGS=({{ARGS}})
  if [[ "{{target}}" == "debug" ]] && ! [[ " {{ARGS}} " =~ " "(-P|--profile)" " ]]
  then
    ARGS+=(--profile debug)
  fi

  if [[ "{{noclean}}" != true ]] && [[ " ${ARGS[*]}" =~ " -"[a-zA-Z0-9]*"f" ]]
  then
    just clean
  fi

  cp mkosi.key mkosi.crt sysexts/

  echo mkosi "${ARGS[@]}" -C sysexts
  mkosi "${ARGS[@]}" -C sysexts

[group("build")]
[arg("noclean", long="no-clean", value="true")]
[arg("nocore", long="no-core", value="true")]
build-system noclean="false" nocore="false" target='release' *ARGS="-i -f": genkey toolstree
  #!/usr/bin/env bash
  set -exuo pipefail
  
  ARGS=({{ARGS}})
  if [[ "{{target}}" == "debug" ]] && ! [[ " {{ARGS}} " =~ " "(-P|--profile)" " ]]
  then
    ARGS+=(--profile debug)
  fi
  deps=()
  if [[ "{{noclean}}" != "true" ]] && [[ " ${ARGS[*]}" =~ " -"[a-zA-Z0-9]*"f" ]]
  then
    just clean
  fi

  cp mkosi.key mkosi.crt system/

  if ! [[ -d portables/mkosi.output/01-base ]] || ! [[ " ${ARGS[*]} " =~ " -"[a-zA-Z0-9]*i[a-zA-Z0-9]*" " ]]
  then
    p_args=()
    [[ "{{nocore}}" != true ]] || p_args+=(--no-core)
    [[ "{{noclean}}" != true ]] || p_args+=(--no-clean)
    just build-portables "${p_args[@]}" "{{target}}" -- "${ARGS[@]}"
  fi

  if ! [[ -d sysexts/mkosi.output/01-base ]] || ! [[ " ${ARGS[*]} " =~ " -"[a-zA-Z0-9]*i[a-zA-Z0-9]*" " ]]
  then
    [[ "{{noclean}}" != true ]] || p_args+=(--no-clean)
    just build-sysexts "${p_args[@]}" "{{target}}" -- "${ARGS[@]}"
  fi

  echo mkosi "${ARGS[@]}" -C system
  mkosi "${ARGS[@]}" -C system

[group("vm")]
qemu target='release' *ARGS="-i":
  #!/usr/bin/env bash
  set -ex

  ARGS=({{ARGS}})

  if [[ "{{target}}" == "debug" ]] && ! [[ " {{ARGS}} " =~ " "(-P|--profile)" " ]]
  then
    ARGS+=(--profile debug)
  fi

  mkdir -p system/mkosi.runtime
  if ! [[ -f system/mkosi.podmancache ]]
  then
    fallocate -l 5G system/mkosi.podmancache
    mkfs.ext4 system/mkosi.podmancache
  fi
  ./scripts/mkscratch.sh
  mkosi vm "${ARGS[@]}" \
  --runtime-tree="$PWD/scratch:/scratch" \
  --machine=ncatomic-test \
  --ephemeral true \
  --drive podmancache:5G::::persist \
  --kernel-command-line-extra '-smbios type=11,value=io.systemd.stub.kernel-cmdline-extra=systemd.mount-extra=LABEL=podmancache:/podman-cache:ext4' \
  -C system

