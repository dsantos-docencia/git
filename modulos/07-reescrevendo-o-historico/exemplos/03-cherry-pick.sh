#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · Módulo 07 · Cherry-pick
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  OBJETIVO  levar um hotfix da main para a release sem trazer o resto
#  EXECUTE   bash modulos/07-reescrevendo-o-historico/exemplos/03-cherry-pick.sh
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
printf 'v1\n' > app.txt && git add . && git commit -q -m "feat: versão 1"
git branch release/1.x
printf 'nova tela\n' > tela.txt && git add . && git commit -q -m "feat: tela nova (só na 2.0)"
printf 'corrigido\n' > seguranca.txt && git add . && git commit -q -m "fix: falha de segurança no login"

passo "1. A release/1.x precisa SÓ do fix de segurança"
git log --oneline --all --graph

passo "2. cherry-pick -x: copia o commit e anota a origem na mensagem"
alvo="$(git log --format=%H -1 --grep='falha de segurança')"
git switch -q release/1.x
git cherry-pick -x "$alvo" >/dev/null
git log -1 --format='%h %s%n%n%b'

passo "3. A release recebeu o fix, mas não a tela nova"
ls
