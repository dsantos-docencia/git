#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · Módulo 08 · Release automática
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  OBJETIVO  Conventional Commits → próxima versão → changelog → tag, com os scripts do curso
#  EXECUTE   bash modulos/08-fluxos-tags-e-releases/exemplos/03-release-automatica.sh
# ============================================================================
set -euo pipefail
# Pasta deste exemplo, calculada ANTES de mudar de diretório (funciona com caminho relativo)
AQUI="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

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
SCRIPTS="$AQUI/../../../scripts/release"

git init -q app && cd app
printf 'v1\n' > app.txt && git add . && git commit -q -m "feat: primeira versão"
git tag -a v1.0.0 -m "Release 1.0.0"
printf 'a\n' > a.txt && git add . && git commit -q -m "fix(carrinho): corrige arredondamento"
printf 'b\n' > b.txt && git add . && git commit -q -m "feat(pedidos): calcula frete por CEP"
printf 'c\n' > c.txt && git add . && git commit -q -m "docs: atualiza README"

passo "1. Commits desde a v1.0.0"
git log --oneline v1.0.0..HEAD

passo "2. Próxima versão (feat → MINOR)"
bash "$SCRIPTS/proxima-versao.sh"

passo "3. Changelog gerado"
bash "$SCRIPTS/gerar-changelog.sh"

passo "4. Uma quebra de compatibilidade vira MAJOR"
printf 'd\n' > d.txt && git add . && git commit -q -m "feat(api)!: remove endpoint /v1/pedidos"
bash "$SCRIPTS/proxima-versao.sh" --tag
git tag -l --sort=-v:refname
