#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · Módulo 06 · Servidor local
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  OBJETIVO  repositório bare, clone, push, fetch e origin/main
#  EXECUTE   bash modulos/06-remotos-e-colaboracao/exemplos/01-servidor-local.sh
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
git config --global pull.rebase false

passo "1. O 'servidor': um repositório bare (só o .git, sem arquivos de trabalho)"
git init -q --bare servidor.git
ls servidor.git

passo "2. Clonando: o Git cria o remoto 'origin' sozinho"
git clone -q servidor.git ana 2>/dev/null
cd ana && git remote -v

passo "3. Primeiro commit e primeiro push (-u liga main → origin/main)"
printf '# Loja\n' > README.md && git add . && git commit -q -m "docs: readme"
git push -q -u origin main
git branch -vv

passo "4. Outra pessoa clona e publica um commit"
cd .. && git clone -q servidor.git bia && cd bia
printf 'frete\n' > frete.txt && git add . && git commit -q -m "feat: frete" && git push -q
cd ../ana

passo "5. Na Ana: antes do fetch, origin/main está desatualizado"
git log --oneline --all

passo "6. fetch baixa e move origin/main — a main local NÃO muda"
git fetch -q
git status -sb | sed -n 1p             # behind 1
git log --oneline --all

passo "7. Integrando (aqui é avanço rápido)"
git merge -q --ff-only origin/main
git log --oneline
