#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · Módulo 06 · Fork e upstream
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  OBJETIVO  contribuir por fork: origin = seu fork, upstream = o original
#  EXECUTE   bash modulos/06-remotos-e-colaboracao/exemplos/03-fork-e-upstream.sh
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

passo "1. O projeto original e o 'fork' (na plataforma seria o botão Fork)"
git init -q --bare original.git
git clone -q original.git mantenedor 2>/dev/null
( cd mantenedor && printf '# Lib\n' > README.md && git add . && git commit -q -m "docs: readme" && git push -q -u origin main )
git clone -q --bare original.git meu-fork.git

passo "2. Você clona o SEU fork e aponta 'upstream' para o original"
git clone -q meu-fork.git voce && cd voce
git remote add upstream ../original.git
git remote -v

passo "3. Trabalho numa branch, publicado no SEU fork (origin)"
git switch -q -c fix/typo
printf '# Lib\nCorreção.\n' > README.md && git commit -q -am "docs: corrige typo"
git push -q -u origin fix/typo
echo "→ Na plataforma, você abriria o Pull Request de voce:fix/typo para original:main"

passo "4. Enquanto isso, o original andou"
( cd ../mantenedor && printf 'x\n' > x.txt && git add . && git commit -q -m "feat: x" && git push -q )

passo "5. Sincronizando o fork: fetch upstream → ff main → push origin"
git switch -q main
git fetch -q upstream
git merge -q --ff-only upstream/main
git push -q origin main
git log --oneline --decorate
