#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · Módulo 10 · Objetos
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  OBJETIVO  ver blobs, trees, commits e tags por dentro, e a deduplicação por conteúdo
#  EXECUTE   bash modulos/10-por-dentro-do-git/exemplos/01-objetos.sh
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

git init -q obj && cd obj
mkdir -p src
printf 'olá\n' > README.md
printf 'olá\n' > src/copia.md          # MESMO conteúdo em outro lugar
printf 'print(1)\n' > src/app.py
git add . && git commit -q -m "feat: primeiro commit"
git tag -a v1.0 -m "Release 1.0"

passo "1. O commit por dentro: tree, autor, committer, mensagem"
git cat-file -p HEAD

passo "2. A tree raiz: nomes → modo, tipo e hash"
git cat-file -p 'HEAD^{tree}'

passo "3. A subpasta src/ é outra tree"
git ls-tree HEAD src/

passo "4. Deduplicação: README.md e src/copia.md apontam para o MESMO blob"
git rev-parse HEAD:README.md HEAD:src/copia.md
echo "e é o mesmo hash que o conteúdo 'olá' teria em qualquer repositório do mundo:"
printf 'olá\n' | git hash-object --stdin

passo "5. A tag anotada é um objeto próprio que aponta para o commit"
git cat-file -t v1.0
git cat-file -p v1.0
