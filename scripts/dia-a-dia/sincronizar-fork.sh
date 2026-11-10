#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · scripts/dia-a-dia/sincronizar-fork.sh
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  O QUE FAZ  Atualiza a branch principal do seu fork com o repositório original
#             (remoto 'upstream') e envia para o seu fork ('origin').
#  USO        sincronizar-fork.sh [branch]            (padrão: main)
#  PRÉ        git remote add upstream <url-do-original>  (uma vez)
# ============================================================================
set -euo pipefail

branch="${1:-main}"
git remote get-url upstream >/dev/null 2>&1 || {
    echo "Remoto 'upstream' não configurado. Ex.: git remote add upstream https://github.com/ORG/PROJETO.git" >&2; exit 1; }
if [[ -n "$(git status --porcelain --untracked-files=no)" ]]; then
    echo "Há mudanças não commitadas. Faça commit ou 'git stash' antes." >&2; exit 1
fi
anterior="$(git branch --show-current)"
git fetch --prune upstream
git switch -q "$branch"
# --ff-only: só avança. Se o seu main tem commits próprios, o script para em vez de criar merge.
git merge --ff-only "upstream/$branch"
git push origin "$branch"
[[ -n "$anterior" && "$anterior" != "$branch" ]] && git switch -q "$anterior"
echo "✔ $branch sincronizada com upstream/$branch e enviada ao origin."
