#!/usr/bin/env bash
# Curso de Git · Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC · não comercial)
# Exercício 03.01 — Mensagem ruim no último commit · SOLUÇÃO COMENTADA
set -euo pipefail

# --amend substitui o último commit; -m define a nova mensagem.
# Como nada foi preparado, o conteúdo do commit continua o mesmo.
git -C app commit -q --amend -m "feat: adiciona login"
