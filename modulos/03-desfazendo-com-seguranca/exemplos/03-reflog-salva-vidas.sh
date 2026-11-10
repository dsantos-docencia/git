#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · Módulo 03 · reflog salva-vidas
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  OBJETIVO  recuperar commits após reset --hard e uma branch apagada
#  EXECUTE   bash modulos/03-desfazendo-com-seguranca/exemplos/03-reflog-salva-vidas.sh
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

git init -q app && cd app
for n in 1 2 3; do printf '%s\n' "$n" > v.txt; git add . && git commit -q -m "versão $n"; done

passo "1. O desastre: reset --hard dois commits para trás"
git reset -q --hard HEAD~2
git log --oneline            # só a versão 1 aparece...

passo "2. O reflog lembra de tudo"
git reflog -5

passo "3. Recuperando: volte a branch para onde ela estava antes do reset"
git reset -q --hard 'HEAD@{1}'
git log --oneline

passo "4. Branch apagada com -D"
git switch -q -c experimento
printf 'ideia\n' > ideia.txt && git add . && git commit -q -m "exp: ideia ousada"
git switch -q main
git branch -D experimento
git branch --list

passo "5. Achando o commit no reflog e recriando a branch"
sha="$(git log -g --format='%h %s' | awk '/exp: ideia ousada/ {print $1; exit}')"
echo "commit encontrado: $sha"
git branch experimento "$sha"
git log --oneline -1 experimento
