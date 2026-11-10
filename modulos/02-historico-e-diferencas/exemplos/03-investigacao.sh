#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · Módulo 02 · Investigação
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  OBJETIVO  descobrir quando, quem e por que a TAXA mudou
#  EXECUTE   bash modulos/02-historico-e-diferencas/exemplos/03-investigacao.sh
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

passo "1. Em que commit o texto TAXA=0.15 APARECEU? (pickaxe -S)"
git log -S'TAXA=0.15' --format='%h %an %ad %s' --date=short

passo "2. Abrindo o commit suspeito"
suspeito="$(git log -S'TAXA=0.15' --format=%h)"
git show --stat "$suspeito"

passo "3. Quem escreveu cada linha do config.ini por último (blame)"
git blame --date=short config.ini

passo "4. Onde mais a TAXA é usada no código? (git grep)"
git grep -n "TAXA" || true
git grep -n "1.15"

passo "5. O valor da taxa na v1.0 (conteúdo de um arquivo numa versão antiga)"
git show v1.0:config.ini | grep TAXA

passo "Conclusão"
echo "O Caio subiu a taxa num commit 'chore: ajusta parâmetros' — mensagem que não explica o porquê."
echo "Lição: a mensagem do commit é a documentação que o blame vai mostrar."
