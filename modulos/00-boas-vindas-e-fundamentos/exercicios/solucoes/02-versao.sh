#!/usr/bin/env bash
# Curso de Git · Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC · não comercial)
# Exercício 00.02 — Só o número da versão · SOLUÇÃO COMENTADA
set -euo pipefail

# A saída tem o formato "git version X.Y.Z[.extra]". Pegamos a 3ª palavra
# e, com um regex, só os três primeiros números (descarta ".windows.1" etc.).
versao="$(git --version | awk '{print $3}')"
if [[ "$versao" =~ ^([0-9]+\.[0-9]+\.[0-9]+) ]]; then
    printf '%s\n' "${BASH_REMATCH[1]}"
fi
