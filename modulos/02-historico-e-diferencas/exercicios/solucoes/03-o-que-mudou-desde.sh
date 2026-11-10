#!/usr/bin/env bash
# Curso de Git · Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC · não comercial)
# Exercício 02.03 — O que mudou desde a v1.0? · SOLUÇÃO COMENTADA
set -euo pipefail

git -C historico diff --name-only v1.0 HEAD | sort
