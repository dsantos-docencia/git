#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · Módulo 05 · Anatomia de um conflito
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  OBJETIVO  provocar, ler e resolver um conflito, com o estilo zdiff3
#  EXECUTE   bash modulos/05-conflitos/exemplos/01-anatomia.sh
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
git config --global merge.conflictStyle zdiff3
montar loja

passo "1. O merge para no conflito (status 1 é esperado)"
git merge feature/imposto || true

passo "2. git status mostra quem está em conflito"
git status --short          # UU = os dois lados modificaram (unmerged)

passo "3. O arquivo com os marcadores — repare na seção ||||||| (o ORIGINAL)"
cat config.ini

passo "4. Resolvendo: a decisão de negócio foi 0.18; apagamos os marcadores"
printf 'MOEDA=BRL\nTAXA=0.18\nFRETE=10\n' > config.ini
git diff --check && echo "(nenhum marcador esquecido)"
git add config.ini
git commit -q --no-edit
git log --oneline --graph
