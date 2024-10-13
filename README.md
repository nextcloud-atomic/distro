# Nextcloud Atomic build code

Repository for building [Nextcloud Atomic](https://nextcloudatomic.com) images.

## Build and run instructions (example for incus container)

```sh
. ./incus.env

# Build incus image
make compile configure cmd/virt/incus/buildimage 

# Run incus container
make cmd/virt/incus/run
```

## Funding

From September 2024 until February 2025, development of Nextcloud Atomic is being funded by the German Federal Ministry of Education and Research as part of the Prototype Fund by the Open Knowledge Foundation Germany.

<img height=80 style="padding: 6px; background-color: white; border-radius: 5px;" alt="BMBF Logo" src="https://nextcloudatomic.com/funding/bmbf_logo.svg">
<img height="80" style="padding: 6px; background-color: white; border-radius: 5px;" alt="Prototype Fund Logo" src="https://nextcloudatomic.com/funding/prototypefund_logo.png">

--- 

# SkiffOS Extensions Template

[SkiffOS](https://github.com/skiffos/skiffos) compiles a lightweight operating
system for any Linux-compatible computer.

This is an example of how Skiff can be extended with custom configuration
packages. Skiff is added as a submodule, and is instructed to use the parent
repo configs directory:

```sh
export SKIFF_EXTRA_CONFIGS_PATH=$(pwd)/configs
```

Then, any extra configuration packages you add in this repo will be available.

To get started:

```sh
make help
```

Alternatively:

```sh
source setup.env
cd ./skiffos
make # this will print help!
```

As a basic example:

```sh
export SKIFF_WORKSPACE=pi4
export SKIFF_CONFIG=pi/4,mycustom/device
make configure compile

# flash to sd card
make cmd/pi/common/{format,install}
```

The example `mycustom/device` package has examples of Wi-Fi configurations, SSH
keys, and other common customizations.

## Configuration Packages

Skiff supports modular configuration packages: kernel & buildroot configs,
root filesystem overlays, patches, hooks, and other resources.

Layers are named as `namespace/name`. For example, a Raspberry Pi 4
configuration would be `pi/4` and Docker is `apps/docker`.

```
├── cflags:         compiler flags in files
├── buildroot:      buildroot configuration fragments
├── buildroot_ext:  buildroot extensions (extra packages)
├── buildroot_patches: extra Buildroot global patches
│   ├── <packagename>: patch files for Buildroot <packagename>
│   └── <packagename>/<version>: patches for package version
├── busybox:        busybox configuration fragments
├── extensions:     extra commands to add to the build system
│   └── Makefile
├── hooks:          scripts hooking pre/post build steps
│   ├── post.sh
│   └── pre.sh
├── kernel:         kernel configuration fragments
├── kernel_patches: kernel .patch files
├── root_overlay:   root overlay files
├── metadata:       metadata files
│   ├── commands
│   ├── dependencies
│   ├── description
│   └── unlisted
├── resources:     files used by the configuration package
├── scripts:       any scripts used by the extensions
├── uboot:         u-boot configuration fragments
├── uboot_patches: u-boot .patch files
└── users:         additional buildroot user config files
```

All files are optional.

### Custom Users

To add custom users, add files in the "users" dir with the [makeuser syntax].

[makeuser syntax]: https://buildroot.org/downloads/manual/manual.html#makeuser-syntax
