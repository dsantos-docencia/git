#!/usr/bin/env bash
# Curso de Git · Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC · não comercial)
# Exercício 01.01 — Primeiro commit · SOLUÇÃO COMENTADA
set -euo pipefail

git init -q -b main projeto
cd projeto
printf '# Projeto\n' > README.md      # printf é mais previsível que echo entre sistemas
git add README.md
git commit -q -m "docs: adiciona README"
