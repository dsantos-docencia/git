#!/usr/bin/env bash
# Curso de Git · Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC · não comercial)
# Exercício 09.03 — Hotfix numa segunda pasta · SOLUÇÃO COMENTADA
set -euo pipefail

cd app
git worktree add -q ../app-hotfix -b hotfix/relatorio main
cd ../app-hotfix
printf 'relatório corrigido\n' > relatorio.txt
git commit -q -am "fix: relatório de vendas"
