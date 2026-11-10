#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · Módulo 11 · Segredo no histórico
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  OBJETIVO  provar que apagar não basta e reescrever o histórico
#  EXECUTE   bash modulos/11-seguranca-hooks-e-automacao/exemplos/03-segredo-no-historico.sh
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
AUDIT="$AQUI/../../../scripts/auditoria"

git init -q loja && cd loja
printf 'print(1)\n' > app.py && git add . && git commit -q -m "feat: app"
printf 'AWS_KEY=AKIAABCDEFGHIJKLMNOP\n' > .env && git add .env && git commit -q -m "chore: config local"
git rm -q .env && git commit -q -m "chore: remove .env"
printf '.env\n' > .gitignore && git add . && git commit -q -m "chore: ignora .env"

passo "1. O arquivo não está no disco nem no último commit…"
ls -a | tr '\n' ' '; echo

passo "2. …mas está no HISTÓRICO, ao alcance de qualquer clone"
git show HEAD~2:.env
bash "$AUDIT/procurar-segredos.sh" . || true

passo "3. Remediação — 1º: REVOGAR a chave na AWS (fora do Git, sempre primeiro!)"
echo "(no mundo real, aqui você troca a credencial)"

passo "4. 2º: reescrever o histórico removendo o .env de todos os commits"
# Recomendado: git filter-repo --path .env --invert-paths
# Aqui usamos o filter-branch (vem com o Git, mas é desaconselhado para uso real).
FILTER_BRANCH_SQUELCH_WARNING=1 git filter-branch -f \
    --index-filter 'git rm -q --cached --ignore-unmatch .env' --prune-empty -- --all >/dev/null
# o filter-branch guarda um backup em refs/original — apagamos e limpamos os objetos antigos
git for-each-ref --format='%(refname)' refs/original | xargs -r -n1 git update-ref -d
git reflog expire --expire=now --all && git gc -q --prune=now

passo "5. Verificando"
git log --oneline --all
bash "$AUDIT/procurar-segredos.sh" .
echo "3º: force-push combinado com o time e pedido de limpeza à plataforma."
