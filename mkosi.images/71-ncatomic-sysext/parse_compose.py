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
    compose["services"][name]["environment"] = new_vars

with open(compose_path, "w") as f:
    yaml.dump(compose, f)