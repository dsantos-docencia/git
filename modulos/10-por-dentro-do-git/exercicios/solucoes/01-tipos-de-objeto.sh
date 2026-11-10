#!/usr/bin/env bash
# Curso de Git · Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC · não comercial)
# Exercício 10.01 — Que objeto é este? · SOLUÇÃO COMENTADA
set -euo pipefail

for obj in HEAD 'HEAD^{tree}' HEAD:README.md v1.0; do
    git -C obj cat-file -t "$obj"
done
