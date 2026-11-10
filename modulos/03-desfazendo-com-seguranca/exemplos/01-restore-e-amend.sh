#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · Módulo 03 · restore e amend
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  OBJETIVO  descartar edições, desfazer o add e consertar o último commit
#  EXECUTE   bash modulos/03-desfazendo-com-seguranca/exemplos/01-restore-e-amend.sh
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
printf 'versão boa\n' > app.py && git add . && git commit -q -m "feat: app"

passo "1. Editei o arquivo errado → git restore descarta a edição"
printf 'bagunça\n' > app.py
git status --short
git restore app.py
cat app.py

passo "2. Dei add sem querer → git restore --staged (a edição continua no disco)"
printf 'mudança ainda em teste\n' >> app.py
git add app.py && git status --short
git restore --staged app.py
git status --short           # ' M' = modificado, mas fora da preparação
git restore app.py           # (limpando para o próximo passo)

passo "3. Commit com mensagem ruim e arquivo esquecido"
printf 'login\n' > login.py
printf 'testes\n' > test_login.py
git add login.py && git commit -q -m "wip"
git log --oneline -1 --stat

passo "4. --amend: inclui o arquivo esquecido e troca a mensagem"
antes="$(git rev-parse --short HEAD)"
git add test_login.py
git commit -q --amend -m "feat: adiciona login com testes"
git log --oneline -1 --stat
echo "hash antes: $antes  ·  depois: $(git rev-parse --short HEAD)  ← é OUTRO commit"
