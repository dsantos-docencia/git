#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · Módulo 05 · ours, theirs e abort
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  OBJETIVO  escolher um lado, resolver por estratégia e desistir com segurança
#  EXECUTE   bash modulos/05-conflitos/exemplos/02-ours-theirs-abort.sh
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

# Monta o cenário: ancestral TAXA=0.12; main muda para 0.15; feature muda para 0.18
montar() {
    git init -q "$1" && cd "$1"
    printf 'MOEDA=BRL\nTAXA=0.12\nFRETE=10\n' > config.ini && git add . && git commit -q -m "feat: config"
    git switch -q -c feature/imposto
    sed -i.bak 's/TAXA=0.12/TAXA=0.18/' config.ini && rm -f config.ini.bak
    git commit -q -am "feat: imposto 18%"
    git switch -q main
    sed -i.bak 's/TAXA=0.12/TAXA=0.15/' config.ini && rm -f config.ini.bak
    git commit -q -am "feat: imposto 15%"
}
montar loja

passo "1. Desistindo: merge --abort volta exatamente ao estado anterior"
git merge feature/imposto >/dev/null 2>&1 || true
git status --short
git merge --abort
git status --short; echo "(limpo)"; grep TAXA config.ini

passo "2. Escolhendo um lado inteiro do arquivo: --theirs (a versão que chega)"
git merge feature/imposto >/dev/null 2>&1 || true
git checkout --theirs config.ini
grep TAXA config.ini
git add config.ini && git commit -q --no-edit
git reset -q --hard HEAD~1           # (desfazendo para o próximo passo)

passo "3. Resolvendo AUTOMATICAMENTE só os trechos em conflito: -X ours"
git merge -q --no-edit -X ours feature/imposto
grep TAXA config.ini
echo "-X ours decidiu o trecho em conflito a favor da main; mudanças sem conflito da feature entrariam normalmente."
