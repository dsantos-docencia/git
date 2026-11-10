#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · Módulo 10 · Refs e packs
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  OBJETIVO  refs como arquivos, packed-refs, gc, objetos inalcançáveis e repositório SHA-256
#  EXECUTE   bash modulos/10-por-dentro-do-git/exemplos/03-refs-e-packs.sh
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

git init -q repo && cd repo
for n in 1 2 3; do printf '%s\n' "$n" > v.txt && git add . && git commit -q -m "v$n"; done
git branch feature && git tag v1

passo "1. Refs: no formato tradicional, arquivos com um hash"
git for-each-ref --format='%(refname) → %(objectname:short)'
echo "Formato das refs deste repositório: $(git rev-parse --show-ref-format 2>/dev/null || echo files)"

passo "2. Objetos soltos antes do gc"
git count-objects -v | grep -E '^(count|in-pack)'

passo "3. gc empacota objetos e refs"
git gc -q
git count-objects -v | grep -E '^(count|in-pack)'
[[ -f .git/packed-refs ]] && { echo "packed-refs:"; grep -v '^#' .git/packed-refs; }

passo "4. Um commit 'perdido' continua no banco até expirar"
perdido="$(git rev-parse HEAD)"
git reset -q --hard HEAD~1
git cat-file -t "$perdido"
echo "Ainda existe (alcançável pelo reflog). Só some depois de expirar reflog + gc.pruneExpire."

passo "5. Um repositório SHA-256 (o padrão previsto para o Git 3.0)"
cd .. && git init -q --object-format=sha256 novo && cd novo
printf 'oi\n' > a.txt && git add . && git commit -q -m "primeiro"
echo "hash com ${#perdido} caracteres (SHA-1) × $(git rev-parse HEAD | tr -d '\n' | wc -c | tr -d ' ') (SHA-256)"
