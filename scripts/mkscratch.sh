#!/usr/bin/bash

mkdir -p scratch/extensions/nca-sysoverlay/usr/lib/extension-release.d scratch/portables

cat > scratch/extensions/nca-sysoverlay/usr/lib/extension-release.d/extension-release.nca-sysoverlay <<'EOF'
ID=debian
VERSION_ID=13
SYSEXT_ID=nca-sysoverlay
SYSEXT_VERSION_ID=devel
SYSEXT_SCOPE=initrd system portable
ARCHITECTURE=x86-64
EOF
