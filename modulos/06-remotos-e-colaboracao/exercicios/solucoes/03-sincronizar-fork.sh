#!/usr/bin/env bash
# Curso de Git · Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC · não comercial)
# Exercício 06.03 — Sincronizar o fork · SOLUÇÃO COMENTADA
set -euo pipefail

cd voce
git remote add upstream ../original.git
git fetch -q upstream
git switch -q main
git merge -q --ff-only upstream/main
git push -q origin main
