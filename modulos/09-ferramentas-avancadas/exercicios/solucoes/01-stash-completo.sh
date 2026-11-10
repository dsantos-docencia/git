#!/usr/bin/env bash
# Curso de Git · Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC · não comercial)
# Exercício 09.01 — Guardar tudo e limpar · SOLUÇÃO COMENTADA
set -euo pipefail

cd app
git stash push -u -m "meio do login"      # -u = --include-untracked
