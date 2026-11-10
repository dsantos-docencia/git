#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · Módulo 02 · Log sob medida
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  OBJETIVO  filtrar e formatar o histórico; seleção de revisão
#  EXECUTE   bash modulos/02-historico-e-diferencas/exemplos/01-log-sob-medida.sh
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

# commit_como AUTOR DATA MENSAGEM — grava um commit com autor e data escolhidos
# (as variáveis GIT_AUTHOR_* e GIT_COMMITTER_DATE valem só para esse comando)
commit_como() {
    GIT_AUTHOR_NAME="$1" GIT_AUTHOR_EMAIL="$(tr 'A-Z' 'a-z' <<<"$1")@loja.dev" \
    GIT_AUTHOR_DATE="$2" GIT_COMMITTER_DATE="$2" git commit -q -m "$3"
}
git init -q loja && cd loja
printf 'MOEDA=BRL\nTAXA=0.12\nFRETE=10\n' > config.ini
printf 'def total(v): return v\n' > app.py
git add . && commit_como Ana  "2026-10-01T09:00" "feat: estrutura da loja"
printf 'def total(v): return v + 10\n' > app.py
git add . && commit_como Bia  "2026-10-03T10:00" "feat: soma o frete no total"
git tag v1.0
sed -i.bak 's/TAXA=0.12/TAXA=0.15/' config.ini && rm config.ini.bak
git add . && commit_como Caio "2026-10-07T16:30" "chore: ajusta parâmetros"
printf 'def total(v): return round(v * 1.15 + 10, 2)\n' > app.py
git add . && commit_como Bia  "2026-10-08T11:00" "feat: aplica imposto no total"

passo "1. Visão geral (com a tag v1.0 decorada)"
git log --oneline --decorate

passo "2. Formato personalizado: hash curto · autor · data · assunto"
git log --format='%h  %<(5)%an %ad  %s' --date=short

passo "3. Só os commits da Bia"
git log --oneline --author=Bia

passo "4. Depois de 5 de outubro"
git log --oneline --since=2026-10-05

passo "5. O que entrou DEPOIS da v1.0 (intervalo v1.0..HEAD)"
git log --oneline v1.0..HEAD

passo "6. Seleção de revisão: HEAD~2 e a mensagem que contém 'frete'"
git log -1 --format='HEAD~2 = %h %s' HEAD~2
git log -1 --format=':/frete = %h %s' ':/frete'

passo "7. Quem mais commitou (shortlog)"
git shortlog -sn HEAD
