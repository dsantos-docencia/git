#!/usr/bin/env bash
# Curso de Git · Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC · não comercial)
# Exercício 08.01 — Marcar uma release antiga · SOLUÇÃO COMENTADA
set -euo pipefail

cd lib
alvo="$(git log --format=%H -F --grep='fix: corrige arredondamento')"
git tag -a v1.3.1 -m "Release 1.3.1" "$alvo"
