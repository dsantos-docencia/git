#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · Módulo 09 · stash e worktree
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  OBJETIVO  parar no meio, atender um hotfix em outra pasta e voltar sem perder nada
#  EXECUTE   bash modulos/09-ferramentas-avancadas/exemplos/01-stash-e-worktree.sh
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
printf 'relatorio v1\n' > relatorio.txt && git add . && git commit -q -m "feat: relatório"
git switch -q -c feature/login
printf 'login meio pronto\n' > login.txt
printf 'relatorio v1 + ajuste local\n' > relatorio.txt

passo "1. Trabalho pela metade (um arquivo novo e um modificado)"
git status --short

passo "2. stash -u: guarda TUDO (inclusive o arquivo novo) e limpa a área"
git stash push -u -m "meio do login"
git status --short; echo "(limpo)"
git stash list

passo "3. worktree: abre a main numa OUTRA pasta, numa branch de hotfix"
git worktree add -q ../loja-hotfix -b hotfix/relatorio main
( cd ../loja-hotfix && printf 'relatorio v1 corrigido\n' > relatorio.txt && git commit -q -am "fix: relatório de vendas" )
git worktree list
git log --oneline hotfix/relatorio -1     # o commit existe aqui também: é o MESMO repositório

passo "4. De volta: pop devolve o trabalho exatamente como estava"
git stash pop -q
git status --short
git worktree remove ../loja-hotfix
