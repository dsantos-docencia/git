#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · Módulo 07 · Rebase linear
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  OBJETIVO  comparar merge e rebase na mesma feature
#  EXECUTE   bash modulos/07-reescrevendo-o-historico/exemplos/01-rebase-linear.sh
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

git init -q base && cd base
printf 'base\n' > app.txt && git add . && git commit -q -m "feat: base"
git switch -q -c feature/cupom
printf 'c1\n' > cupom.txt && git add . && git commit -q -m "feat: modelo de cupom"
printf 'c2\n' >> cupom.txt && git commit -q -am "feat: valida cupom"
git switch -q main
printf 'fix\n' > fix.txt && git add . && git commit -q -m "fix: corrige total"
cd .. && cp -r base com-merge && cp -r base com-rebase

passo "1. Integrando com MERGE: o histórico mostra a bolha"
git -C com-merge merge -q --no-edit feature/cupom
git -C com-merge log --oneline --graph

passo "2. Integrando com REBASE: reaplica a feature em cima da main"
antes="$(git -C com-rebase rev-parse --short feature/cupom)"
git -C com-rebase switch -q feature/cupom
git -C com-rebase rebase -q main
depois="$(git -C com-rebase rev-parse --short feature/cupom)"
git -C com-rebase switch -q main
git -C com-rebase merge -q --ff-only feature/cupom     # agora é avanço rápido
git -C com-rebase log --oneline --graph
echo "Ponta da feature antes do rebase: $antes · depois: $depois  ← commits NOVOS"
