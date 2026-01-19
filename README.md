# Nextcloud Atomic build code

Repository for building [Nextcloud Atomic](https://nextcloudatomic.com) images.

## Build and run instructions (example for incus vm)

```sh
# Build and run qemu vm
just qemu release -f
```

## File structure

```
.
├── docs # project documentation
├── mkosi.common # mkosi configuration/scripts that are used in other places
├── overlays # deprecated
├── portables # mkosi config for various portable services
├── src # sources for building binaries
├── sysexts # mkosi config for building systemd sysexts
├── system # mkosi config for building system image
└── tools # mkosi config for building the tool tree
```

## Funding

From September 2024 until February 2025, development of Nextcloud Atomic is being funded by the German Federal Ministry of Education and Research as part of the Prototype Fund by the Open Knowledge Foundation Germany.

<img height=80 style="padding: 6px; background-color: white; border-radius: 5px;" alt="BMBF Logo" src="https://nextcloudatomic.com/funding/bmbf_logo.svg">
<img height="80" style="padding: 6px; background-color: white; border-radius: 5px;" alt="Prototype Fund Logo" src="https://nextcloudatomic.com/funding/prototypefund_logo.png">


