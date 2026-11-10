#!/usr/bin/env bash
# Curso de Git · Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC · não comercial)
# Exercício 05.03 — Desistir com segurança · SOLUÇÃO COMENTADA
set -euo pipefail

cd loja
git merge feature/imposto >/dev/null 2>&1 || true
git merge --abort        # volta ao estado anterior ao merge
