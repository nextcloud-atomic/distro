# use skiffos as buildsystem

- Status: superseded by [20251226-use-mkosi-as-buildsystem](20251226-use-mkosi-as-buildsystem.md)
- Deciders: Tobias Knöppler
- Date: 2024-08-01
- Tags: buildsystem, os, historic

## Context and Problem Statement

The process of building an immutable Linux distribution can be helped tremendously by using a specialized build system.
However, a choice has to be made for the right tool for the job.

## Decision Drivers <!-- optional -->

- Hardware/platform support: Nextcloud Atomic strives for wide support for not only VMs but also SBCs (often ARM based).
  The build system should accommodate this.
- Container support: For Nextcloud All-in-One, docker/podman support is required. The build system should have good
  support for a popular OCI container runtime.
- Software support: Whatever build system used, it should provide a way to install popular system packages and required
  software by Nextcloud Atomic to reduce the maintenance burden on NC Atomic itself.
- Security: Since NC Atomic is a platform that provides web services, security should be a priority within the build
  systems's ecosystem

## Considered Options

- [SkiffOS](https://github.com/skiffos/skiffos)
- [BuildRoot](https://buildroot.org/)
- [Yocto](https://www.yoctoproject.org/)
- [Fedora IoT](https://fedoraproject.org/iot/)/[Fedora CoreOs](https://fedoraproject.org/coreos/)

## Decision Outcome

Chosen option: **SkiffOS**, because

1. It's based on buildroot and thus provides great hardware support.
2. It provides an immutable OS out of the box with container support.
3. It's a lot easier to work with than buildroot directly.

### Positive Consequences <!-- optional -->

- Simple build system with immutability built-in.
- container support out of the box.
- support for everything that's provided by buildroot (packages, target platforms, hardware)
- reproducibility of builds

## Pros and Cons of the Options <!-- optional -->

### SkiffOS

> SkiffOS is a config package system for the Buildroot OS cross-compiler.
> 
> - Run any distribution anywhere: decouples hardware support from user distro environments.
> - Reliable: minimal read-only host system for unbreakable boot-ups and over-the-air updates.
> - Reproducible: offline builds, pinned package versions, source-controlled custom configs.

- Good, because it's based on buildroot and provides access to lots of packages and target platforms ootb.
- Good, because it's easier to work with than buildroot directly.
- Good, because of built-in container support and immutability
- Bad, because it inherits the long build times from Buildroot
- Bad, because it is backed by a single developer

### BuildRoot

> Buildroot is a simple, efficient and easy-to-use tool to generate embedded Linux systems through cross-compilation.

- Good, because of wide support for packages 
- Good, because of wide support for various target platforms
- Good, because buildroot has a healthy community and ecosystem
- Bad, because it is challenging to configure and build times are long
- Bad, due to lack of built-in support for docker/podman or immutability

### Yocto

> The Yocto Project (YP) is an open source collaboration project that helps developers create custom Linux-based systems
> regardless of the hardware architecture.

- Good, because of wide support for packages
- Good, because of wide support for various target platforms
- Good, because buildroot has a healthy community and ecosystem
- Bad, because of high complexity and steep learning curve (more complex than buildroot)
- Bad, due too long build times (similar to buildroot)

## Fedora IoT/Fedora CoreOS

> Fedora Internet of Things is a Fedora Edition to provide a strong foundation for IoT ecosystems.

> Fedora CoreOS is an automatically updating, minimal, monolithic, container-focused operating system, designed for
> clusters but also operable standalone, optimized for Kubernetes but also great without it.

- Good, because both Fedora derivatives are backed by the mature fedora ecosystem (package support, security, etc.)
- Good, because Fedora IoT claims good support for IoT devices and SBCs
- Good, because Fedora CoreOS has good built-in container support, immutability and atomic updates
- Bad, because either options lacks core features from the other that are required by NC Atomic (ARM support, immutability, ...)
- Bad, because Fedora IoT didn't seem very mature at the time of the decision.

