#!/usr/bin/env bash
# Curso de Git · Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC · não comercial)
# Exercício 02.02 — Quem mudou a taxa? · SOLUÇÃO COMENTADA
set -euo pipefail

# -S'texto' = commits que mudaram a quantidade de ocorrências do texto
# --format=%s = só o assunto
git -C historico log -S'TAXA=0.15' --format=%s
