#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · Módulo 09 · submódulo e sparse checkout
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  OBJETIVO  um repositório dentro de outro e baixar só parte de um monorepo
#  EXECUTE   bash modulos/09-ferramentas-avancadas/exemplos/03-submodulo-e-sparse.sh
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
# Submódulos locais exigem liberar o protocolo "file" (desde o Git 2.38.1, por segurança)
git config --global protocol.file.allow always

git init -q lib-pagamentos
( cd lib-pagamentos && printf 'pagar()\n' > pag.txt && git add . && git commit -q -m "feat: pagar" )

passo "1. Adicionando a lib como submódulo do projeto"
git init -q loja && cd loja
printf '# Loja\n' > README.md && git add . && git commit -q -m "docs: readme"
git submodule add -q ../lib-pagamentos libs/pagamentos
git commit -q -m "build: adiciona lib de pagamentos como submódulo"
cat .gitmodules
echo "O repositório pai guarda só o PONTEIRO (um commit):"
git ls-tree HEAD libs/pagamentos

passo "2. Quem clona precisa pedir os submódulos"
cd ..
git clone -q loja clone-sem
ls clone-sem/libs/pagamentos | wc -l | sed 's/^/arquivos sem --recurse-submodules: /'
git clone -q --recurse-submodules loja clone-com 2>/dev/null
ls clone-com/libs/pagamentos

passo "3. Sparse checkout: num monorepo, só as pastas que interessam"
git init -q mono && cd mono
mkdir -p apps/web apps/mobile libs/ui
for d in apps/web apps/mobile libs/ui; do printf 'x\n' > "$d/arquivo.txt"; done
git add . && git commit -q -m "feat: monorepo"
cd .. && git clone -q --no-checkout mono mono-parcial && cd mono-parcial
git sparse-checkout set apps/web libs/ui
git checkout -q main
find . -path ./.git -prune -o -type f -print | sort
