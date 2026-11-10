#!/usr/bin/env bash
# Curso de Git · Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC · não comercial)
# Exercício 05.01 — Resolver à mão · SOLUÇÃO COMENTADA
set -euo pipefail

cd loja
git merge feature/imposto >/dev/null 2>&1 || true   # o conflito faz o merge sair com status 1
printf 'MOEDA=BRL\nTAXA=0.18\nFRETE=12\n' > config.ini   # conteúdo final, SEM marcadores
git add config.ini                                   # "resolvi"
git commit -q --no-edit                              # conclui o merge
