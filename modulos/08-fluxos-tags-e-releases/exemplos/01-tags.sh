#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · Módulo 08 · Tags
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  OBJETIVO  tag leve × anotada, ordem por versão, describe e push de tags
#  EXECUTE   bash modulos/08-fluxos-tags-e-releases/exemplos/01-tags.sh
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

git init -q lib && cd lib
for v in 1.9.0 1.10.0 2.0.0-rc.1; do
    printf '%s\n' "$v" > VERSAO && git add . && git commit -q -m "chore: prepara $v"
    git tag -a "v$v" -m "Release $v"
done
git tag v-teste-leve HEAD~1

passo "1. Leve × anotada: a anotada é um OBJETO (tipo 'tag'); a leve aponta direto para o commit"
git cat-file -t v1.10.0
git cat-file -t v-teste-leve
git show --no-patch --format='%h %s' v1.10.0 | tail -1

passo "2. Ordenação: texto × versão"
echo "-- sort de texto (errado para versões):"; git tag -l 'v[0-9]*' | sort
echo "-- --sort=-v:refname (versão, mais nova primeiro):"; git tag -l 'v[0-9]*' --sort=-v:refname

passo "3. describe: onde estou em relação à última tag"
printf 'trabalho\n' > novo.txt && git add . && git commit -q -m "feat: novo"
git describe --tags

passo "4. Tags não sobem no push comum"
git init -q --bare ../servidor.git && git remote add origin ../servidor.git
git push -q origin main
echo "tags no servidor após push: $(git -C ../servidor.git tag | wc -l | tr -d ' ')"
git push -q --follow-tags origin main
echo "após --follow-tags (só ANOTADAS alcançáveis): $(git -C ../servidor.git tag | paste -sd' ' -)"
