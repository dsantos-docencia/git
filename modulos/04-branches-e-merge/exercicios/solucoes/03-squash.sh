#!/usr/bin/env bash
# Curso de Git · Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC · não comercial)
# Exercício 04.03 — Integrar com squash · SOLUÇÃO COMENTADA
set -euo pipefail

cd loja
git switch -q main
git merge -q --squash feature/login       # prepara as mudanças, sem criar commit
git commit -q -m "feat: login completo"
# O squash não liga os históricos: para o Git a feature NÃO foi mesclada → -D
git branch -q -D feature/login
