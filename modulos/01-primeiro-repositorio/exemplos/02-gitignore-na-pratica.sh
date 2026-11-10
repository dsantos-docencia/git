#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · Módulo 01 · gitignore na prática
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  OBJETIVO  padrões do .gitignore, exceções, check-ignore e o caso do arquivo já rastreado
#  EXECUTE   bash modulos/01-primeiro-repositorio/exemplos/02-gitignore-na-pratica.sh
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

git init -q app && cd app
mkdir -p build logs
touch app.py build/app.bin logs/erro.log logs/manter.log .env

passo "1. Sem .gitignore: tudo aparece como não rastreado"
git status --short --untracked-files=all

passo "2. Criando o .gitignore"
cat > .gitignore <<'IGN'
build/
*.log
!logs/manter.log
.env
IGN
cat .gitignore
git status --short --untracked-files=all

passo "3. Por que o erro.log está ignorado? (qual regra, de qual arquivo, em qual linha)"
git check-ignore -v logs/erro.log
git check-ignore -v logs/manter.log
echo "↑ regra começando com ! = exceção: logs/manter.log NÃO é ignorado"

passo "4. Armadilha: o .gitignore não age sobre o que JÁ foi commitado"
git add app.py .gitignore && git add -f .env    # -f força (simulando o erro clássico)
git commit -q -m "chore: commit inicial (com .env por engano)"
echo "SENHA=nova" > .env
git status --short     # o .env aparece como modificado: ele continua rastreado!

passo "5. Correção: parar de rastrear sem apagar o arquivo local"
git rm -q --cached .env
git commit -q -m "chore: para de versionar .env"
git status --short; [[ -f .env ]] && echo ".env (o arquivo continua no disco)"
echo "ATENÇÃO: a senha antiga continua no HISTÓRICO. Em caso real: troque a senha (Módulo 11)."
