#!/usr/bin/env bash
# Curso de Git · Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC · não comercial)
# Exercício 08.03 — Notas da versão · SOLUÇÃO COMENTADA
set -euo pipefail

# --reverse = do mais antigo para o mais novo · --format=%s = só o assunto
git -C app log --reverse --format=%s v1.0.0..v1.1.0 \
  | sed -n -E 's/^feat(\([^)]*\))?!?:[[:space:]]*//p'   # -n + p: imprime só as linhas que casaram
