#!/usr/bin/env bash
# Curso de Git · Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC · não comercial)
# Exercício 06.02 — Atualizar a main com segurança · SOLUÇÃO COMENTADA
set -euo pipefail

cd ana
git fetch -q origin
git merge -q --ff-only origin/main      # ou: git pull --ff-only
