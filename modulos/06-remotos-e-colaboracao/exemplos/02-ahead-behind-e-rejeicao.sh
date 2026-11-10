#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · Módulo 06 · ahead, behind e push recusado
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  OBJETIVO  duas pessoas no mesmo arquivo: rejeição, pull com merge e com rebase
#  EXECUTE   bash modulos/06-remotos-e-colaboracao/exemplos/02-ahead-behind-e-rejeicao.sh
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
git init -q --bare servidor.git
git clone -q servidor.git ana 2>/dev/null
( cd ana && printf 'a\n' > a.txt && git add . && git commit -q -m "feat: a" && git push -q -u origin main )
git clone -q servidor.git bia

passo "1. Ana e Bia commitam ao mesmo tempo (arquivos diferentes)"
( cd ana && printf 'ana\n' > ana.txt && git add . && git commit -q -m "feat: parte da Ana" && git push -q )
cd bia && printf 'bia\n' > bia.txt && git add . && git commit -q -m "feat: parte da Bia"

passo "2. O push da Bia é RECUSADO: o servidor tem um commit que ela não tem"
git push 2>&1 | grep -E 'rejected|fetch first' || true
git fetch -q && git status -sb | sed -n 1p      # ahead 1, behind 1

passo "3. pull com merge: integra criando um commit de merge"
git pull -q --no-rebase --no-edit
git log --oneline --graph
git push -q && echo "push ok"

passo "4. Mesmo cenário, agora com pull --rebase: histórico linear"
cd ../ana && git pull -q
printf 'mais\n' >> ana.txt && git commit -q -am "feat: mais da Ana" && git push -q
cd ../bia && printf 'mais\n' >> bia.txt && git commit -q -am "feat: mais da Bia"
git pull -q --rebase
git log --oneline --graph -4
git push -q && echo "push ok"

passo "5. --force-with-lease protege o trabalho dos outros"
cd ../ana && git pull -q
git commit -q --amend -m "feat: mais da Ana (mensagem corrigida)"   # reescreve um commit JÁ publicado...
( cd ../bia && printf 'novo\n' > novo.txt && git add . && git commit -q -m "feat: novo da Bia" && git push -q )
git push --force-with-lease 2>&1 | grep -E 'stale info|rejected' || true
echo "A lease falhou: a Bia publicou depois do último fetch da Ana. Um --force comum teria apagado o commit dela."
