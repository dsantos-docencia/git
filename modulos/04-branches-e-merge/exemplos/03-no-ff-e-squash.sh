#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · Módulo 04 · --no-ff e --squash
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  OBJETIVO  integrar o mesmo trabalho de dois jeitos e comparar os históricos
#  EXECUTE   bash modulos/04-branches-e-merge/exemplos/03-no-ff-e-squash.sh
# ============================================================================
set -euo pipefail

# --- Laboratório descartável --------------------------------------------------
# Pasta temporária apagada ao final; configuração isolada (não lê nem altera o
# seu ~/.gitconfig); identidade fixa para os commits de demonstração.
LAB="$(mktemp -d)"; trap 'rm -rf -- "$LAB"' EXIT; cd "$LAB"
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL="$LAB/.gitconfig-lab" GIT_PAGER=cat
export GIT_AUTHOR_NAME='Ana Dev' GIT_AUTHOR_EMAIL='ana@exemplo.dev'
export GIT_COMMITTER_NAME='Ana Dev' GIT_COMMITTER_EMAIL='ana@exemplo.dev'
git config --global init.defaultBranch main
git config --global advice.detachedHead false
passo() { printf '\n== %s ==\n' "$*"; }

git init -q base && cd base
printf 'base\n' > app.txt && git add . && git commit -q -m "feat: base"
git switch -q -c feature/login
for passo_n in 1 2 3; do printf 'passo %s\n' "$passo_n" >> login.txt; git add . && git commit -q -m "wip: login passo $passo_n"; done
git switch -q main
cd .. && cp -r base noff && cp -r base squash

passo "1. --no-ff: preserva os 3 commits e registra um commit de merge"
git -C noff merge -q --no-ff feature/login -m "Merge: login"
git -C noff log --oneline --graph

passo "2. --squash: as mudanças viram UM commit novo; os 'wip' não entram na main"
git -C squash merge -q --squash feature/login
git -C squash commit -q -m "feat: login completo"
git -C squash log --oneline --graph

passo "3. Atenção ao --squash"
git -C squash branch --merged main | sed 's/^/merged: /'
echo "A feature/login NÃO aparece como mesclada: o squash não liga os históricos."
echo "Por isso, depois de um squash, a branch é apagada com -D (força)."
