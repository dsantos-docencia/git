#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · Módulo 08 · GitHub flow
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  OBJETIVO  branch curta → revisão → merge na main → tag, com servidor local
#  EXECUTE   bash modulos/08-fluxos-tags-e-releases/exemplos/02-github-flow.sh
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
git config --global pull.rebase false
git init -q --bare servidor.git
git clone -q servidor.git dev 2>/dev/null && cd dev
printf '# Loja\n' > README.md && git add . && git commit -q -m "docs: readme" && git push -q -u origin main
git tag -a v1.0.0 -m "Release 1.0.0" && git push -q origin v1.0.0

passo "1. Branch curta a partir da main atualizada"
git switch -q -c feature/cupom
printf 'cupom\n' > cupom.txt && git add . && git commit -q -m "feat: cupom de desconto"
git push -q -u origin feature/cupom
echo "→ Pull Request aberto na plataforma · CI roda · alguém revisa"

passo "2. Aprovado: merge na main (na plataforma, o botão 'Merge')"
git switch -q main && git pull -q
git merge -q --no-ff feature/cupom -m "Merge pull request #12 from feature/cupom"
git push -q
git push -q origin --delete feature/cupom && git branch -q -d feature/cupom

passo "3. Release: feat → MINOR → v1.1.0"
git tag -a v1.1.0 -m "Release 1.1.0"
git push -q origin v1.1.0
git log --oneline --graph --decorate
