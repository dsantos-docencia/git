#!/usr/bin/env bash
# Curso de Git · Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC · não comercial)
# Exercício 08.02 — Qual é a última versão? · SOLUÇÃO COMENTADA
set -euo pipefail

# --sort=-v:refname ordena como VERSÃO, da maior para a menor; pegamos a primeira
git -C lib tag -l 'v[0-9]*' --sort=-v:refname | sed -n 1p
