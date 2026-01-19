# separate mkosi configurations for service images and sysexts

- Status: accepted
- Deciders: Tobias Knöppler
- Date: 2025-12-27
- Tags: mkosi, project-structure

## Context and Problem Statement

Having the mkosi configuration for system extensions (sysexts) and service images in the same place, makes it slower
and more difficult to develop and test the latter.

## Decision Drivers <!-- optional -->

- (Portable) service images can be tested in isolation, therefore it makes sense to be able to build them exclusively.

## Considered Options

- common overlays directory: Keep sysexts and service images in one common mkosi config directory (`/overlays`)
- separate directories: Move sysexts and service images in separate mkosi config directories (`/sysexts` and `/portables`)

## Decision Outcome

Chosen option: "separate directories", to allow for easier testing of service images.

### Positive Consequences <!-- optional -->

- Service images can now be built separately which simplifies and accelerates the test and development process.

### Negative Consequences <!-- optional -->

- The build process has become more complex (three mkosi build steps instead of two)

## Links <!-- optional -->

- Supersedes [20250727-restructure-into-multiple-mkosi-configs](20250727-restructure-into-multiple-mkosi-configs.md)
