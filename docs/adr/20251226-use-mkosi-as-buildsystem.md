# use mkosi as buildsystem

- Status: accepted
- Deciders: Tobias Knöppler
- Date: 2025-01-01
- Tags: buildsystem, os, historic

## Context and Problem Statement

SkiffOS (and, by proxy, buildroot) as buildsystem turned out to provide suboptimal support for security related features
and access to up-to-date packages. Therefore, it needed to be replaced by something else.

## Decision Drivers <!-- optional -->

- No ootb support for trusted boot in SkiffOS
- Some packages in buildroot sources are very out of date (specifically, podman)
- No ootb support for full disk encryption in SkiffOS
- Security features like SELinux/AppArmor, Firewall, WAF are an afterthought in buildroot

## Considered Options

- mkosi
- … <!-- numbers of options can vary -->

## Decision Outcome

Chosen option: "mkosi", because it allows using a mature Linux distribution as base (allowing access to all it's
packages and configurations), has first class support for many advanced systemd features and is used by a number of
similar projects (e.g. incus OS).

### Positive Consequences <!-- optional -->

- easy support for readonly /usr, trusted boot, encrypted data partition, systemd-update ...
- Access to security features of popular Linux distribution (debian in this case)
- It *should* be easy to replace plain debian with an Armbian base for SBCs
- modular build system, allowing to build systemd-extensions and base image separately
- More active community

### Negative Consequences <!-- optional -->

- No ootb support for SBCs
- Loss (or reimplementation) of SkiffOS specific feature set (guest OS for user services)

## Pros and Cons of the Options <!-- optional -->

### mkosi

> A fancy wrapper around dnf --installroot, apt, pacman and zypper that generates customized disk images with a number
> of bells and whistles.

- Good, because of first-class support for systemd features
- Good, because of ootb support for trusted boot, full disk encryption, TPM 2.0, ...
- Good, because of very straight forward work flow
- Good, because it allows to use a common Linux distribution as base, giving access to all of its features
- Good, because of good support for hermetic /usr partition
- Good, because of good support for atomic updates via systemd-sysupdate
- Good, because it might allow the use of multiple base operating systems given the need for that

## Links <!-- optional -->

- Supersedes [202408081-use-skiffos-as-buildsystem](202408081-use-skiffos-as-buildsystem.md)
