#!/usr/bin/env bash
# Curso de Git · Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC · não comercial)
# Exercício 05.02 — Escolher um lado do arquivo · SOLUÇÃO COMENTADA
set -euo pipefail

cd loja
git merge feature/imposto >/dev/null 2>&1 || true
git checkout --theirs config.ini      # "theirs" = a branch que está sendo mesclada
git add config.ini
git commit -q --no-edit
