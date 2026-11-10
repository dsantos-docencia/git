#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · Módulo 01 · Commits coesos
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  OBJETIVO  separar mudanças em commits com intenção única; rm, mv e rm --cached
#  EXECUTE   bash modulos/01-primeiro-repositorio/exemplos/03-commits-coesos.sh
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

git init -q loja && cd loja
printf 'def frete(): return 10\n' > frete.py
printf 'def desconto(): return 0\n' > desconto.py
git add . && git commit -q -m "feat: estrutura inicial"

passo "1. Duas mudanças independentes no trabalho"
printf 'def frete(): return 12  # tabela 2026\n' > frete.py
printf 'def desconto(): return 5\n' > desconto.py
git status --short

passo "2. Um commit por intenção"
git add frete.py   && git commit -q -m "fix: atualiza frete para a tabela 2026"
git add desconto.py && git commit -q -m "feat: aplica desconto padrão de 5"
git log --oneline

passo "3. Renomear com git mv (o Git registra como renomeação)"
git mv desconto.py promocoes.py
git status --short
git commit -q -m "refactor: renomeia desconto para promocoes"

passo "4. Remover com git rm (apaga e prepara a remoção num passo)"
git rm -q frete.py
git commit -q -m "refactor: remove cálculo de frete legado"

passo "5. Histórico final com estatísticas por commit"
git log --stat --format='%n%h %s'
