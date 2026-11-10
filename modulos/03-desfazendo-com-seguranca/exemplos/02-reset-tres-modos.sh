#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · Módulo 03 · reset em três modos e revert
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  OBJETIVO  comparar --soft, --mixed, --hard e desfazer em público com revert
#  EXECUTE   bash modulos/03-desfazendo-com-seguranca/exemplos/02-reset-tres-modos.sh
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

# monta 3 commits e copia o repositório para comparar os modos lado a lado
git init -q base && cd base
for n in 1 2 3; do printf 'linha %s\n' "$n" >> notas.txt; git add . && git commit -q -m "nota $n"; done
cd ..
for modo in soft mixed hard; do cp -r base "$modo"; done

for modo in soft mixed hard; do
    passo "git reset --$modo HEAD~1"
    git -C "$modo" reset -q --"$modo" HEAD~1
    echo "log:    $(git -C "$modo" log --format=%s | paste -sd, -)"
    echo "status: '$(git -C "$modo" status --short)'"
    echo "disco:  $(tail -1 "$modo/notas.txt")"
done
echo
echo "soft  → a 'nota 3' voltou PREPARADA (status 'M ')"
echo "mixed → voltou MODIFICADA, fora da preparação (status ' M')"
echo "hard  → DESCARTADA: o arquivo voltou à nota 2"

passo "revert: desfazer um commit publicado SEM reescrever o histórico"
cd base
git revert --no-edit HEAD >/dev/null
git log --oneline
tail -1 notas.txt
