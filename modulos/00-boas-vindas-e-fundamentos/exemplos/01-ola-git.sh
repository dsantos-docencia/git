#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · Módulo 00 · Olá, Git
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  OBJETIVO  ver a versão, criar o primeiro repositório e espiar a pasta .git
#  EXECUTE   bash modulos/00-boas-vindas-e-fundamentos/exemplos/01-ola-git.sh
# ============================================================================
set -euo pipefail

# --- Laboratório descartável: pasta temporária + configuração isolada ----------
# Nada aqui lê ou altera o seu ~/.gitconfig: o nível "global" aponta para um
# arquivo dentro da pasta temporária, apagada ao final (trap ... EXIT).
LAB="$(mktemp -d)"; trap 'rm -rf -- "$LAB"' EXIT; cd "$LAB"
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL="$LAB/.gitconfig-lab" GIT_PAGER=cat
passo() { printf '\n== %s ==\n' "$*"; }

passo "1. Qual Git está instalado?"
git --version

passo "2. Criando um repositório (-b main define o nome da branch inicial)"
git init -q -b main meu-projeto
cd meu-projeto
echo "Repositório criado em: $(pwd)"

passo "3. O repositório É a pasta .git — veja o que tem dentro"
# HEAD    = em que branch você está
# config  = configuração LOCAL deste repositório
# objects = onde o conteúdo (commits, arquivos) é guardado
# refs    = branches e tags (ponteiros para commits)
ls -1 .git

passo "4. Para onde o HEAD aponta?"
cat .git/HEAD

passo "5. O Git ainda não tem nenhum commit"
git status --short --branch

passo "Conclusão"
echo "Apagar a pasta .git = apagar todo o histórico. Os seus arquivos continuam lá."
