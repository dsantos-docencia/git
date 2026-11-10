#!/usr/bin/env bash
# Curso de Git · Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC · não comercial)
# Exercício 02.01 — Quantos commits? · SOLUÇÃO COMENTADA
set -euo pipefail

# rev-list lista commits; --count devolve só a quantidade. Estável para scripts.
git -C historico rev-list --count HEAD
