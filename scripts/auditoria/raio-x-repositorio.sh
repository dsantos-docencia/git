#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · scripts/auditoria/raio-x-repositorio.sh
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  O QUE FAZ  Relatório rápido de um repositório: tamanho, commits, quem mais
#             contribui, branches paradas e os maiores arquivos do HISTÓRICO.
#  USO        raio-x-repositorio.sh [pasta-do-repo] [--top N]
#  POR QUÊ    Primeiro passo ao assumir um projeto (ou antes de migrar de
#             plataforma): saber o tamanho e onde estão os 'elefantes'.
# ============================================================================
set -euo pipefail

repo="."; top=5
while (( $# )); do
    case "$1" in
        --top) top="${2:?}"; shift 2 ;;
        *) repo="$1"; shift ;;
    esac
done
cd "$repo"
git rev-parse --git-dir >/dev/null 2>&1 || { echo "não é um repositório Git: $repo" >&2; exit 1; }

secao() { printf '\n## %s\n' "$*"; }
echo "# Raio-X de $(basename "$(git rev-parse --show-toplevel)")"

secao "Números"
printf 'Commits (HEAD): %s\n' "$(git rev-list --count HEAD)"
printf 'Branches locais: %s · tags: %s\n' "$(git for-each-ref refs/heads | wc -l | tr -d ' ')" "$(git tag | wc -l | tr -d ' ')"
printf 'Primeiro commit: %s\n' "$(git log --reverse --format='%ad' --date=short | head -1)"
printf 'Último commit:   %s\n' "$(git log -1 --format='%ad' --date=short)"
git count-objects -vH | awk '/size-pack|^size:/ {print "Armazenamento " $0}'

secao "Quem mais contribui (top $top)"
git shortlog -sn --no-merges HEAD | head -n "$top"

secao "Branches por data do último commit"
git for-each-ref --sort=-committerdate refs/heads \
    --format='%(committerdate:short)  %(refname:short)  (%(authorname))'

secao "Maiores arquivos de TODO o histórico (top $top)"
# rev-list --objects lista todo objeto alcançável; cat-file --batch-check traz tipo e tamanho
git rev-list --objects --all \
  | git cat-file --batch-check='%(objecttype) %(objectsize) %(rest)' \
  | awk '$1 == "blob" && $3 != "" {printf "%10d bytes  %s\n", $2, $3}' \
  | sort -rn | awk '!visto[$3]++' | head -n "$top"
