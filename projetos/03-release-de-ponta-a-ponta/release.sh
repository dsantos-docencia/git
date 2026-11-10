#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · Projeto 03 · Release de ponta a ponta
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  USO      release.sh [--branch main] [--publicar]
#  FAZ      1. confere: na branch certa, área limpa, igual ao origin
#           2. calcula a versão pelos Conventional Commits (scripts/release)
#           3. acrescenta as notas no topo do CHANGELOG.md
#           4. commit "chore(release): vX.Y.Z" + tag anotada
#           5. com --publicar: push da branch e da tag
#  SAÍDA    0 ok · 1 pré-condição falhou · 3 nada a lançar
#  MÓDULOS  06 (fetch, ahead/behind), 08 (Conventional Commits, SemVer, tags)
# ============================================================================
set -euo pipefail

AQUI="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REL="$AQUI/../../scripts/release"
branch="main"; publicar=0
while (( $# )); do
    case "$1" in
        --branch)   branch="${2:?}"; shift 2 ;;
        --publicar) publicar=1; shift ;;
        -h|--help)  sed -n '5,13p' "$0"; exit 0 ;;
        *) echo "opção desconhecida: $1" >&2; exit 2 ;;
    esac
done
falhar() { printf '✘ %s\n' "$*" >&2; exit 1; }

# 1. Pré-condições ------------------------------------------------------------
git rev-parse --git-dir >/dev/null 2>&1 || falhar "rode dentro de um repositório Git"
[[ "$(git branch --show-current)" == "$branch" ]] || falhar "troque para a branch $branch antes da release"
[[ -z "$(git status --porcelain)" ]] || falhar "há mudanças não commitadas"
if git remote get-url origin >/dev/null 2>&1; then
    git fetch -q --tags origin
    read -r atras frente < <(git rev-list --left-right --count "origin/$branch...$branch")
    (( atras == 0 )) || falhar "$branch está $atras commit(s) atrás do origin — faça pull"
    (( frente == 0 )) || falhar "$branch tem $frente commit(s) não publicados — publique ou revise antes"
fi

# 2. Versão --------------------------------------------------------------------
set +e; versao="$(bash "$REL/proxima-versao.sh" 2>/dev/null)"; st=$?; set -e
(( st == 3 )) && { echo "Nada a lançar (sem feat/fix/breaking desde a última versão)."; exit 3; }
(( st == 0 )) || falhar "não foi possível calcular a versão"

# 3. Changelog -----------------------------------------------------------------
notas="$(bash "$REL/gerar-changelog.sh" | sed "1s/^## HEAD\$/## $versao/")"
{
    printf '%s\n\n' "$notas"
    [[ -f CHANGELOG.md ]] && cat CHANGELOG.md
} > CHANGELOG.md.novo
mv CHANGELOG.md.novo CHANGELOG.md

# 4. Commit e tag --------------------------------------------------------------
git add CHANGELOG.md
git commit -q -m "chore(release): $versao"
git tag -a "$versao" -m "Release $versao"
echo "✔ $versao: commit e tag criados."

# 5. Publicação ----------------------------------------------------------------
if (( publicar )); then
    PERMITIR_PUSH_MAIN=1 git push -q --follow-tags origin "$branch"
    echo "✔ publicado em origin/$branch com a tag $versao."
else
    echo "Revise e publique com: git push --follow-tags origin $branch   (ou rode de novo com --publicar)"
fi
