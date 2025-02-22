#!/bin/env python

import yaml
import sys

compose_path=sys.argv[1]
with open(sys.argv[1], "r") as f:
    compose = yaml.safe_load(f)

for name, svc in compose["services"].items():
    new_vars = []
    for env_var in svc["environment"]:
        if "=" not in env_var:
            new_vars.append(f"{env_var}=${'{'}{env_var}{'}'}")
        else:
            new_vars.append(env_var)
    if name == "nextcloud-aio-nextcloud":
        new_vols = []
        for vol in svc["volumes"]:
            if vol.startswith("nextcloud_aio_nextcloud:"):
                vol = vol.replace("nextcloud_aio_nextcloud:", "${NEXTCLOUD_INSTALLDIR}:", 1)
            new_vols.append(vol)
        compose["services"][name]["volumes"] = new_vols
    compose["services"][name]["environment"] = new_vars

with open(compose_path, "w") as f:
    yaml.dump(compose, f)