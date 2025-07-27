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
  rm -rf mkosi.images/82-nca-web-svc/mkosi.extra/usr/share/ncatomic/nca-web/public || :;
  cp -r "src/core/out/{{target}}/nca-web/public" mkosi.images/82-nca-web-svc/mkosi.extra/usr/share/ncatomic/nca-web/
  cp    "src/core/out/{{target}}/nca-web/ncatomic-web" mkosi.images/82-nca-web-svc/mkosi.extra/usr/share/ncatomic/nca-web/ncatomic-web
  cp    "src/core/out/{{target}}/"{nca-logs,nca-system,ncatomic,occ,occd} mkosi.images/71-ncatomic-sysext/mkosi.extra/usr/bin/

clean:
  #!/usr/bin/env bash
  set -ex
  just nca-core::clean || :;
  ! [[ -d mkosi.output ]] || sudo rm -rf ./mkosi.output/*

build target='release' *ARGS="-if":
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

  if ! [[ " ${ARGS}" =~ " --no-core" ]]
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

  if ! [[ -d overlays/mkosi.output/NextcloudAtomicOverlays ]] || ! [[ " ${args[*]} " =~ " -"[a-zA-Z0-9]*i[a-zA-Z0-9]*" " ]]
  then
    mkosi "${args[@]}" -C overlays
  fi

  mkosi "${args[@]}" -C system

qemu target='release' *ARGS="-if":
  #!/usr/bin/env bash
  set -ex

  just build {{target}} {{ARGS}}

  args=({{ARGS}})
  if [[ "${args[*]}" == "--no-core" ]]
  then
    args+=("-if")
  fi

  filtered=()
  for arg in "${args[@]}"
  do
    if [[ "$arg" =~ ^"--" ]]
    then
      if [[ "$arg" != "--force" ]] && [[ "$arg" != "--no-core" ]]
      then
        filtered+=("$arg")
      fi
    elif [[ "$arg" =~ ^"-" ]]
    then
      filtered+=("${arg//f/}")
    else
      filtered+=("$arg")
    fi
  done

  echo "args: ${filtered[@]}"
  sleep 10

  #mkosi "${filtered[@]}" --machine=ncatomic-test --ephemeral true vm
  mkosi "${filtered[@]}" --machine=ncatomic-test --ephemeral true vm

