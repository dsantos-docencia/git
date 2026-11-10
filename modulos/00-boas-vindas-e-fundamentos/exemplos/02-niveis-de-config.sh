#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · Módulo 00 · Níveis de configuração
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  OBJETIVO  mostrar global × local × -c e qual valor vence
#  EXECUTE   bash modulos/00-boas-vindas-e-fundamentos/exemplos/02-niveis-de-config.sh
# ============================================================================
set -euo pipefail

# --- Laboratório descartável: pasta temporária + configuração isolada ----------
# Nada aqui lê ou altera o seu ~/.gitconfig: o nível "global" aponta para um
# arquivo dentro da pasta temporária, apagada ao final (trap ... EXIT).
LAB="$(mktemp -d)"; trap 'rm -rf -- "$LAB"' EXIT; cd "$LAB"
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL="$LAB/.gitconfig-lab" GIT_PAGER=cat
passo() { printf '\n== %s ==\n' "$*"; }

passo "1. Configuração GLOBAL (no laboratório, um arquivo temporário)"
git config --global user.name  "Ana Pessoal"
git config --global user.email "ana@pessoal.dev"
git config --global --list

passo "2. Um repositório da empresa com configuração LOCAL"
git init -q -b main trabalho && cd trabalho
git config --local user.email "ana@empresa.com.br"

passo "3. Qual e-mail vale aqui dentro? (o mais específico vence)"
git config --get user.email

passo "4. De onde vem cada valor?"
git config --list --show-scope --show-origin | grep -E 'user\.'

passo "5. -c sobrescreve tudo, só para um comando"
git -c user.email="teste@temporario" config --get user.email

passo "6. Fora do repositório, vale o global"
cd .. && git config --get user.email
