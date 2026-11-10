#!/usr/bin/env bash
# Curso de Git · Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC · não comercial)
# Exercício 04.02 — Merge de três vias registrado · SOLUÇÃO COMENTADA
set -euo pipefail

cd loja
git switch -q main
# --no-ff força o commit de merge (aqui ele já seria necessário, mas deixamos explícito)
git merge -q --no-ff feature/cupom -m "Merge: cupom de desconto"
