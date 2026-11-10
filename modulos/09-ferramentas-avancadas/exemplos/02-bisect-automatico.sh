#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · Módulo 09 · bisect automático
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  OBJETIVO  encontrar entre 40 commits o que introduziu um bug, com git bisect run
#  EXECUTE   bash modulos/09-ferramentas-avancadas/exemplos/02-bisect-automatico.sh
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

git init -q loja && cd loja
# 40 commits; no 27º, alguém troca a soma por uma subtração no "relatório"
for n in $(seq 1 40); do
    if (( n < 27 )); then op='+'; else op='-'; fi
    printf 'total = a %s b\n' "$op" > relatorio.txt
    printf '%s\n' "$n" > versao.txt
    git add . && git commit -q -m "chore: alteração $n"
    (( n == 1 )) && git tag v1.0
done

# O teste: sai 0 se o relatório soma (bom), 1 se não (ruim)
cat > ../teste-relatorio.sh <<'T'
#!/usr/bin/env bash
grep -q 'a + b' relatorio.txt
T
chmod +x ../teste-relatorio.sh

passo "1. Sabemos: HEAD está ruim, v1.0 estava boa. 40 commits = no máximo ~6 testes"
git bisect start HEAD v1.0 >/dev/null

passo "2. bisect run: o Git testa sozinho, por busca binária"
git bisect run ../teste-relatorio.sh 2>&1 | grep -E "^\[" | sed "s/^\[[0-9a-f]*\] /testou: /"

passo "3. O culpado"
git log -1 --format='%h %s' refs/bisect/bad
git bisect reset >/dev/null 2>&1
