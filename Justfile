fetch-core:
  #!/usr/bin/env bash
  set -ex
  mkdir -p ./src
  [ -d ./src/core ] || git submodule add https://github.com/nextcloud-atomic/core.git ./src/core
  ( cd ./src/core && git pull; )

mod? nca-core 'src/core/Justfile'

clean-core:
  @just nca-core::clean
  echo "done."
  
build-core target='release':
  #!/usr/bin/env bash
  set -ex
  just nca-core::build --docker "{{target}}"
  rm -rf portables/mkosi.images/04-nca-web-svc/nca-web.extra/usr/share/ncatomic/nca-web/public || :;
  cp -r "src/core/out/{{target}}/nca-web/public" portables/mkosi.images/04-nca-web-svc/nca-web.extra/usr/share/ncatomic/nca-web/
  cp    "src/core/out/{{target}}/nca-web/ncatomic-web" portables/mkosi.images/04-nca-web-svc/nca-web.extra/usr/share/ncatomic/nca-web/ncatomic-web
  cp    "src/core/out/{{target}}/"{nca-logs,nca-system,ncatomic,occ,occd} sysexts/mkosi.images/11-ncatomic-sysext/mkosi.extra/usr/bin/

clean:
  #!/usr/bin/env bash
  set -ex
  just nca-core::clean || :;
  ! [[ -d mkosi.output ]] || sudo rm -rf ./mkosi.output/*

build target='release' *ARGS="-i strict -f":
  #!/usr/bin/env bash
  set -ex
  
  ARGS="{{ARGS}}"
  if [[ "${ARGS}" == "--no-core" ]]
  then
    ARGS="-if --no-core"
  fi
  deps=()
  if [[ " ${ARGS}" =~ " -"[a-zA-Z0-9]*"f" ]]
  then
    deps+=(clean)
  fi

  if ! [[ " ${ARGS} " =~ " --no-core " ]]
  then
    deps+=(build-core {{target}})
  fi

  echo "Running with deps: ${deps[@]}"

  just "${deps[@]}"

  args=()
  for arg in ${ARGS}
  do
    if [[ "$arg" != "--no-core" ]]
    then
      args+=("$arg")
    fi
  done

  [[ -f mkosi.key ]] || {
    mkosi genkey
    cp mkosi.key mkosi.crt portables/
    cp mkosi.key mkosi.crt system/
  }

  if ! [[ -d portables/mkosi.output/NextcloudAtomicPortables ]] || ! [[ " ${args[*]} " =~ " -"[a-zA-Z0-9]*i[a-zA-Z0-9]*" " ]]
  then
    mkosi "${args[@]}" -C portables
  fi

  if ! [[ -d sysexts/mkosi.output/NextcloudAtomicSysexts ]] || ! [[ " ${args[*]} " =~ " -"[a-zA-Z0-9]*i[a-zA-Z0-9]*" " ]]
  then
    mkosi "${args[@]}" -C sysexts
  fi

  echo mkosi "${args[@]}" -C system
  mkosi "${args[@]}" -C system

qemu target='release' *ARGS="-i strict -f":
  #!/usr/bin/env bash
  set -ex

  ARGS=({{ARGS}})
  build_args=()
  vm_args=()
  while [[ -n "${ARGS[*]}" ]]
  do
    if ! [[ " ${ARGS[0]} " =~ " --runtime-tree=".*" " ]]
    then
      build_args+=("${ARGS[0]}")
    fi
    if [[ "${ARGS[0]}" != "--no-core" ]]
    then
      vm_args+=("${ARGS[0]}")
    fi
    ARGS=("${ARGS[@]:1}")
  done

  if [[ "${vm_args[*]}" == "--no-core" ]]
  then
    build_args+=("-i" "strict" "-f")
    vm_args+=("-i" "strict")
  fi

  if [[ "{{target}}" == "debug" ]] && ! [[ " {{ARGS}} " =~ " "(-P|--profile)" " ]]
  then
    vm_args+=(--profile debug)
    build_args+=(--profile debug)
  fi

  filtered=()
  for arg in "${vm_args[@]}"
  do
    if [[ "$arg" =~ ^"--" ]]
    then
      if [[ "$arg" != "--force" ]] && [[ "$arg" != "--no-core" ]]
      then
        filtered+=("$arg")
      fi
    elif [[ "$arg" =~ ^"-" ]] && [[ "$arg" != "-f" ]]
    then
      filtered+=("${arg//f/}")
    elif [[ "$arg" != "-f" ]]
    then
      filtered+=("$arg")
    fi
  done

  if [[ " $ARGS " =~ .*" --rebuild " ]]
  then
    echo "Building with args: ${build_args[@]}"

    just build {{target}} "${build_args[@]}"

    echo "build complete"
  fi


  mkdir -p system/mkosi.runtime
  if ! [[ -f system/mkosi.podmancache ]]
  then
    fallocate -l 5G system/mkosi.podmancache
    mkfs.ext4 system/mkosi.podmancache
  fi
  #mkosi "${filtered[@]}" --machine=ncatomic-test --ephemeral true vm
  ./scripts/mkscratch.sh
  mkosi vm "${filtered[@]}" --runtime-tree="$PWD/scratch:/scratch" --machine=ncatomic-test --ephemeral true -C system

