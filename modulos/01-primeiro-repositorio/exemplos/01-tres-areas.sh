#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · Módulo 01 · As três áreas
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  OBJETIVO  acompanhar um arquivo por todos os estados com git status --short
#  EXECUTE   bash modulos/01-primeiro-repositorio/exemplos/01-tres-areas.sh
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

git init -q api-pedidos && cd api-pedidos
# Legenda do status curto: 1ª coluna = área de preparação · 2ª = diretório de trabalho
#   ??  não rastreado   A  adicionado   M  modificado   (espaço) sem mudança

passo "1. Arquivo novo: não rastreado (??)"
echo "# API de Pedidos" > README.md
git status --short

passo "2. git add: vai para a área de preparação (A na 1ª coluna)"
git add README.md
git status --short

passo "3. git commit: vira histórico; status fica limpo"
git commit -q -m "docs: cria README"
git status --short; echo "(nada a mostrar)"
git log --oneline

passo "4. Editando de novo: modificado, NÃO preparado (' M')"
echo "Serviço que recebe pedidos da loja." >> README.md
git status --short
git diff            # o que mudou e ainda não foi preparado

passo "5. Preparado ('M '): agora git diff fica vazio e git diff --staged mostra a mudança"
git add README.md
git status --short
git diff --staged --stat

passo "6. Editar DEPOIS do add ('MM'): metade preparada, metade não"
echo "Responsável: time de pedidos." >> README.md
git status --short
echo "Só o que foi preparado entra no commit:"
git commit -q -m "docs: descreve o serviço"
git status --short    # a última linha continua modificada
