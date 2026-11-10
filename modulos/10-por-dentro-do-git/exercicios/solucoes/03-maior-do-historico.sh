#!/usr/bin/env bash
# Curso de Git · Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC · não comercial)
# Exercício 10.03 — O maior arquivo de todos os tempos · SOLUÇÃO COMENTADA
set -euo pipefail

git -C app rev-list --objects --all \
  | git -C app cat-file --batch-check='%(objecttype) %(objectsize) %(rest)' \
  | awk '$1 == "blob" { print $2, $3 }' \
  | sort -rn | sed -n '1s/^[0-9]* //p'
