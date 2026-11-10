#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · Módulo 00 · Pedindo ajuda
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  OBJETIVO  usar -h, a lista de comandos e os guias do próprio Git
#  EXECUTE   bash modulos/00-boas-vindas-e-fundamentos/exemplos/03-pedindo-ajuda.sh
# ============================================================================
set -euo pipefail

# --- Laboratório descartável: pasta temporária + configuração isolada ----------
# Nada aqui lê ou altera o seu ~/.gitconfig: o nível "global" aponta para um
# arquivo dentro da pasta temporária, apagada ao final (trap ... EXIT).
LAB="$(mktemp -d)"; trap 'rm -rf -- "$LAB"' EXIT; cd "$LAB"
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL="$LAB/.gitconfig-lab" GIT_PAGER=cat
passo() { printf '\n== %s ==\n' "$*"; }

passo "1. Resumo rápido das opções de um comando (-h)"
# 'git <cmd> -h' imprime o uso e sai com código 129 — por isso o '|| true'.
git commit -h 2>&1 | head -n 12 || true

passo "2. Guias conceituais disponíveis (git help -g)"
git help -g 2>/dev/null | head -n 15 || echo "(manual não instalado nesta máquina — veja https://git-scm.com/docs)"

passo "3. Quantos comandos o seu Git tem?"
git help -a 2>/dev/null | grep -cE '^   [a-z]' || true

passo "4. Dica"
echo "Manual completo: git help <comando>   ·   online: https://git-scm.com/docs/git-<comando>"
