#!/usr/bin/env bash
# Curso de Git · Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC · não comercial)
# Exercício 04.01 — Feature com avanço rápido · SOLUÇÃO COMENTADA
set -euo pipefail

git init -q -b main loja && cd loja
printf 'base\n' > app.txt && git add . && git commit -q -m "feat: base"
git switch -q -c feature/frete
printf 'frete\n' > frete.txt && git add . && git commit -q -m "feat: frete"
git switch -q main
git merge -q --ff-only feature/frete      # --ff-only garante: ou avanço rápido, ou erro
git branch -q -d feature/frete            # -d: só apaga se já estiver mesclada
