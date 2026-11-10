#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · Módulo 05 · rerere
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  OBJETIVO  deixar o Git repetir uma resolução de conflito já feita
#  EXECUTE   bash modulos/05-conflitos/exemplos/03-rerere.sh
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

# Monta o cenário: ancestral TAXA=0.12; main muda para 0.15; feature muda para 0.18
montar() {
    git init -q "$1" && cd "$1"
    printf 'MOEDA=BRL\nTAXA=0.12\nFRETE=10\n' > config.ini && git add . && git commit -q -m "feat: config"
    git switch -q -c feature/imposto
    sed -i.bak 's/TAXA=0.12/TAXA=0.18/' config.ini && rm -f config.ini.bak
    git commit -q -am "feat: imposto 18%"
    git switch -q main
    sed -i.bak 's/TAXA=0.12/TAXA=0.15/' config.ini && rm -f config.ini.bak
    git commit -q -am "feat: imposto 15%"
}
git config --global rerere.enabled true
montar loja

passo "1. Primeiro conflito: resolvemos à mão (o rerere GRAVA a resolução)"
git merge feature/imposto >/dev/null 2>&1 || true
printf 'MOEDA=BRL\nTAXA=0.18\nFRETE=10\n' > config.ini
git add config.ini && git commit -q --no-edit

passo "2. Desfazemos o merge (como num rebase repetido ou num teste de integração)"
git reset -q --hard HEAD~1

passo "3. O mesmo conflito de novo: o rerere aplica a resolução gravada"
git merge feature/imposto 2>&1 | grep -i -E 'resolved|conflict' || true
grep TAXA config.ini
echo "O arquivo já veio resolvido. Revise e conclua com git add + git commit."
git add config.ini && git commit -q --no-edit
