#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · Módulo 10 · Commit à mão
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  OBJETIVO  construir um commit usando apenas comandos de encanamento
#  EXECUTE   bash modulos/10-por-dentro-do-git/exemplos/02-commit-a-mao.sh
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

git init -q manual && cd manual

passo "1. Gravar o blob (o conteúdo) no banco de objetos"
blob="$(printf 'feito à mão\n' | git hash-object -w --stdin)"
echo "blob: $blob"

passo "2. Colocar o blob no índice com nome e permissão"
git update-index --add --cacheinfo "100644,$blob,leia-me.txt"
git ls-files -s

passo "3. Gravar a tree a partir do índice"
tree="$(git write-tree)"
echo "tree: $tree"

passo "4. Gravar o commit (sem pai: é o primeiro)"
commit="$(git commit-tree "$tree" -m "feat: commit feito à mão")"
echo "commit: $commit"

passo "5. Mover a branch para o commit novo"
git update-ref refs/heads/main "$commit"
git log --oneline
git status --short; echo "(o leia-me.txt ainda não está no disco — atualizamos só o repositório)"
git restore leia-me.txt && cat leia-me.txt
