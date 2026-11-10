#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · Módulo 04 · Branch é ponteiro
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  OBJETIVO  ver a branch como arquivo, o HEAD, e commits avançando só a branch atual
#  EXECUTE   bash modulos/04-branches-e-merge/exemplos/01-branch-e-ponteiro.sh
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
printf 'v1\n' > app.txt && git add . && git commit -q -m "feat: v1"

passo "1. Criando uma branch: nada é copiado, só nasce um ponteiro"
git branch feature/frete
git rev-parse main feature/frete          # os dois apontam para o MESMO commit
cat .git/HEAD                             # HEAD → main

passo "2. switch: o HEAD passa a apontar para a feature"
git switch -q feature/frete
cat .git/HEAD
git branch --show-current

passo "3. Commitando: só a branch atual avança"
printf 'frete por CEP\n' > frete.txt && git add . && git commit -q -m "feat: frete por CEP"
git log --oneline --decorate --all

passo "4. Voltando para a main: o arquivo frete.txt 'some' (ele está na outra branch)"
git switch -q main
ls

passo "5. HEAD destacado: olhando um commit antigo sem branch"
git switch -q --detach main~0
git status | sed -n 1p
git switch -q main
echo "Dica: em HEAD destacado, crie uma branch (git switch -c nome) antes de commitar."
