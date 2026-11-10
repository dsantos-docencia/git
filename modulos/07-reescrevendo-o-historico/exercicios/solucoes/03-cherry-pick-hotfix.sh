#!/usr/bin/env bash
# Curso de Git · Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC · não comercial)
# Exercício 07.03 — Hotfix na release · SOLUÇÃO COMENTADA
set -euo pipefail

cd loja
alvo="$(git log main --format=%H -F --grep='fix: falha de segurança no login')"
git switch -q release/1.x
git cherry-pick -x "$alvo" >/dev/null
