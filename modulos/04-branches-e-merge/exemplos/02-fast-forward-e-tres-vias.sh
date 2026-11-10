#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · Módulo 04 · Avanço rápido e três vias
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  OBJETIVO  ver os dois tipos de merge acontecendo
#  EXECUTE   bash modulos/04-branches-e-merge/exemplos/02-fast-forward-e-tres-vias.sh
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

git init -q loja && cd loja
printf 'base\n' > app.txt && git add . && git commit -q -m "feat: base"

passo "1. Avanço rápido: a main não andou enquanto a feature trabalhava"
git switch -q -c feature/a
printf 'a\n' > a.txt && git add . && git commit -q -m "feat: a"
git switch -q main
git merge feature/a                       # repare: "Fast-forward"
git log --oneline --graph

passo "2. Três vias: as duas linhas andaram"
git switch -q -c feature/b
printf 'b\n' > b.txt && git add . && git commit -q -m "feat: b"
git switch -q main
printf 'hotfix\n' > hotfix.txt && git add . && git commit -q -m "fix: hotfix na main"
git merge --no-edit feature/b             # repare: "Merge made by the 'ort' strategy"
git log --oneline --graph

passo "3. O commit de merge tem DOIS pais"
git log -1 --format='commit %h · pais: %p'
