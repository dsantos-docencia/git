#!/usr/bin/env bash
# Curso de Git · Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC · não comercial)
# Exercício 00.03 — De onde vem esta configuração? · SOLUÇÃO COMENTADA
set -euo pipefail

git init -q -b main projeto
git -C projeto config --local core.editor nano
# --show-scope antepõe o nível (system/global/local/command) ao valor
git -C projeto config --show-scope --get core.editor
