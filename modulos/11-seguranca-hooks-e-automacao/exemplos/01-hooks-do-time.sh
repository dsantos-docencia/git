#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · Módulo 11 · Hooks do time
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  OBJETIVO  hooks versionados (core.hooksPath) recusando segredo e mensagem fora do padrão
#  EXECUTE   bash modulos/11-seguranca-hooks-e-automacao/exemplos/01-hooks-do-time.sh
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
HOOKS="$AQUI/../../../scripts/hooks"

git init -q loja && cd loja
printf '# Loja\n' > README.md && git add . && git commit -q -m "docs: readme"

passo "1. Instalando os hooks do curso numa pasta VERSIONADA"
bash "$HOOKS/instalar-hooks.sh"
git config --get core.hooksPath
ls .githooks

passo "2. Tentando commitar um .env → recusado pelo pre-commit"
printf 'SENHA=123\n' > .env && git add -f .env
git commit -q -m "chore: config" || echo "→ commit RECUSADO (status $?)"
git restore --staged .env && rm .env

passo "3. Mensagem fora do padrão → recusada pelo commit-msg"
printf 'x\n' > app.py && git add app.py
git commit -q -m "ajustes" || echo "→ commit RECUSADO"

passo "4. Mensagem no padrão → aceita"
git commit -q -m "feat: estrutura do app"
git log --oneline -1

passo "5. Os hooks entram no repositório como qualquer arquivo"
git add .githooks && git commit -q -m "chore: adiciona hooks do time"
git ls-files .githooks
