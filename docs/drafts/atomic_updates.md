# Atomic Updates

## Updatable components

### Disk images

- `/root`, `/usr` respectively
- `/boot`

**Installed to:** respective partition

**PostInstall:** (Soft-)reboot

### System Extensions

- nc atomic extension
- podman / nc aio extension

**Installed to:** `/var/lib/extensions`
**Versions in:** `/var/lib/extensions.available`

**PostInstall:** restart depending services(?)

Updated as single component, always to the same version.

### Portable Services

- caddy
- nc-aio
- nca-core/-web

**Installed to:** `/var/lib/portables`
**Versions in:** `/var/lib/portables.available`

**PostInstall:** Reattach portable services

Updates a separate components per service.

## Update Process

1. Look for new system extension images and download them to `/var/lib/extensions.available`, updating symlinks to `/var/lib/extensions`
2. Look for new portable service images and download them to `/var/lib/portables.available`, updating symlinks to `/var/lib/portables`

