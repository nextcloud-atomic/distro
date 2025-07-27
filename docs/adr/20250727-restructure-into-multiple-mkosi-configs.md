# Restructure into multiple mkosi configs

- Status: accepted
- Deciders: @theCalcaholic
- Date: 2025-07-26
- Tags: mkosi, project-structure

Technical Story: [description | ticket/issue URL] <!-- optional -->

## Context and Problem Statement

We want to make the build system more flexible by allowing service images to be built separately from the main OS image.
What project structure should we use?

## Decision Drivers

- A full rebuild of the final image takes very long
- Images should be updated in a running VM using Nextcloud Atomic's update mechanism
- Base Image and service images should still share some configuration

## Considered Options

1. Use mkosi profiles to enable/disable specific config options
2. Use 3 separate build configs: a base image, the collection of service images, the main image
3. Use 2 separate build configs that share common configuration via `Include=`: the collection of service images, the main image

## Decision Outcome

Chosen option: "Use 2 separate build configs", because it is less complex in terms of configuration than the other options

- Service images will live in `./service_images`.
- The main image will live in `./system`.
- Shared config will live in `./mkosi.common`.

### Positive Consequences

- Service images can be built separate from the base image and pushed to a running VM

### Negative Consequences

- Justfile must manage two dependant mkosi build commands

## Pros and Cons of the Options

### 1. Use mkosi profiles to enable/disable specific config options

- Bad, because the configuration logic would be very complex
- Bad, because it's unclear whether this could solve the issue at all

### 2. Use 3 separate build configs: a base image, the collection of service images, the main image

- Good, because it might result in better caching over over option 3
- Bad, because it would offload complex depency logic to the Justfile
- Bad, because it would reduce transparency of the build config

### 3. Use 2 separate build configs that share common configuration via `Include=`: the collection of service images, the main image

- Good, because allows separate building of service images and main image with a minimum of entry points
- Bad, because it might cause packages to be downloaded/installed twice (no shared base image)
