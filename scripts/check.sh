#!/usr/bin/env bash
# Verificación completa del proyecto: lo mismo en local (antes de abrir el PR) y en CI.
# Tiene que acabar en error si algo falla. El curso es solo Markdown: se comprueba lo barato y
# determinista. Necesita python3 con PyYAML.
set -euo pipefail
cd "$(dirname "$0")/.."

paso() { printf '\n\033[1;34m== %s\033[0m\n' "$*"; }

paso "Sintaxis de los scripts de shell"
git ls-files -z '*.sh' '.githooks/*' | xargs -0 -r -n1 bash -n

paso "YAML y JSON válidos"
git ls-files -z '*.yml' '*.yaml' '*.json' | python3 -c '
import json, sys, yaml
for f in sys.stdin.read().split("\0"):
    if not f:
        continue
    with open(f, encoding="utf-8") as fh:
        json.load(fh) if f.endswith(".json") else yaml.safe_load(fh)
'

paso "Enlaces relativos entre ficheros del curso"
python3 scripts/check-enlaces.py

echo
echo "check.sh: todo bien"
