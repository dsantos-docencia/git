#!/usr/bin/env bash
# Curso de Git · Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC · não comercial)
# Exercício 01.02 — Preparação seletiva · SOLUÇÃO COMENTADA
set -euo pipefail

git init -q -b main projeto
cd projeto
printf 'versão 1\n' > a.txt
printf 'rascunho\n' > b.txt
git add a.txt                         # só o a.txt entra
git commit -q -m "feat: adiciona a"
printf 'versão 2\n' > a.txt
git add a.txt                         # preparado, mas sem commit
