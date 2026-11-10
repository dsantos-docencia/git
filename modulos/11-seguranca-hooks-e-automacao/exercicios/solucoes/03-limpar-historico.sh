#!/usr/bin/env bash
# Curso de Git · Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC · não comercial)
# Exercício 11.03 — Tirar o segredo do histórico · SOLUÇÃO COMENTADA
set -euo pipefail

cd loja
if git filter-repo --version >/dev/null 2>&1; then
    git filter-repo --force --quiet --path .env --invert-paths
else
    FILTER_BRANCH_SQUELCH_WARNING=1 git filter-branch -f \
        --index-filter 'git rm -q --cached --ignore-unmatch .env' --prune-empty -- --all >/dev/null
    git for-each-ref --format='%(refname)' refs/original | xargs -r -n1 git update-ref -d
fi
