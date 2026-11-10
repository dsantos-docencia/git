#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · Módulo 07 · Rebase interativo
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  OBJETIVO  squash, fixup, reword e drop sem abrir editor (GIT_SEQUENCE_EDITOR)
#  EXECUTE   bash modulos/07-reescrevendo-o-historico/exemplos/02-rebase-interativo.sh
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
printf 'base\n' > app.txt && git add . && git commit -q -m "feat: base"
printf '1\n' > cupom.txt && git add . && git commit -q -m "feat: modelo de cupom"
printf '2\n' >> cupom.txt && git commit -q -am "wip"
printf 'debug\n' > debug.txt && git add . && git commit -q -m "debug temporário"
printf '3\n' >> cupom.txt && git commit -q -am "fet: valida cupom"

passo "1. Antes: commits que você não quer no Pull Request"
git log --oneline

passo "2. A lista que o editor mostraria (git rebase -i HEAD~4)"
# GIT_SEQUENCE_EDITOR=cat apenas IMPRIME a lista; o rebase segue sem alterações.
GIT_SEQUENCE_EDITOR='cat' git rebase -q -i HEAD~4 | sed 's/^/   /' || true

passo "3. Editando a lista por script: wip → fixup · debug → drop · fet → reword"
# GIT_SEQUENCE_EDITOR recebe o arquivo da lista; o sed troca as palavras no lugar.
# GIT_EDITOR responde ao "reword" com a mensagem nova.
GIT_SEQUENCE_EDITOR="sed -i.bak -e 's/^pick \([0-9a-f]*\) wip$/fixup \1 wip/' -e 's/^pick \([0-9a-f]*\) debug/drop \1 debug/' -e 's/^pick \([0-9a-f]*\) fet:/reword \1 fet:/'" \
GIT_EDITOR="sed -i.bak '1s/.*/feat: valida cupom/'" \
git rebase -q -i HEAD~4

passo "4. Depois: dois commits limpos, e o debug sumiu"
git log --oneline
ls

passo "5. O atalho --fixup + --autosquash"
# Esqueci o teste do modelo de cupom: crio um commit "fixup!" apontando para ele
printf 'teste\n' > teste_cupom.txt && git add teste_cupom.txt
git commit -q --fixup=":/modelo de cupom"
git log --oneline -2
GIT_SEQUENCE_EDITOR=true git rebase -q -i --autosquash HEAD~3
git log --oneline
