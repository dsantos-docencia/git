#!/usr/bin/env bash
# Curso de Git · Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC · não comercial)
# Exercício 06.01 — Publicar uma branch com upstream · SOLUÇÃO COMENTADA
set -euo pipefail

cd ana
git switch -q -c feature/frete
printf 'frete\n' > frete.txt && git add . && git commit -q -m "feat: frete"
git push -q -u origin feature/frete     # -u = --set-upstream
