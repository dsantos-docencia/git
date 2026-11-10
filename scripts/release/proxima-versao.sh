#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · scripts/release/proxima-versao.sh
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  O QUE FAZ  Calcula a próxima versão SemVer a partir dos commits (Conventional
#             Commits) desde a última tag vX.Y.Z — e, com --tag, cria a tag.
#  REGRAS     'tipo!:' ou 'BREAKING CHANGE' no corpo → MAJOR · feat → MINOR ·
#             fix/perf → PATCH · outros (docs, chore…) → sem nova versão
#  USO        proxima-versao.sh [--tag]
#  SAÍDA      imprime a versão (ex.: v1.3.0); status 3 = nada a lançar
# ============================================================================
set -euo pipefail

criar_tag=0
[[ "${1:-}" == "--tag" ]] && criar_tag=1

ultima="$(git describe --tags --abbrev=0 --match 'v[0-9]*.[0-9]*.[0-9]*' 2>/dev/null || echo v0.0.0)"
if [[ ! "$ultima" =~ ^v([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
    echo "última tag fora do padrão vX.Y.Z: $ultima" >&2; exit 2
fi
maior="${BASH_REMATCH[1]}" menor="${BASH_REMATCH[2]}" patch="${BASH_REMATCH[3]}"

intervalo="HEAD"; [[ "$ultima" != "v0.0.0" ]] && intervalo="$ultima..HEAD"

nivel=0     # 0 nada · 1 patch · 2 minor · 3 major
# %s = assunto, %b = corpo; separador de registro \x1e para tratar corpos com várias linhas
while IFS= read -r -d $'\x1e' registro; do
    registro="${registro#$'\n'}"          # o git log separa os registros com uma quebra de linha
    assunto="${registro%%$'\n'*}"
    if [[ "$assunto" =~ ^[a-z]+(\(.+\))?!: ]] || [[ "$registro" == *"BREAKING CHANGE"* ]]; then
        nivel=3
    elif [[ "$assunto" =~ ^feat(\(.+\))?: ]]; then
        (( nivel < 2 )) && nivel=2
    elif [[ "$assunto" =~ ^(fix|perf)(\(.+\))?: ]]; then
        (( nivel < 1 )) && nivel=1
    fi
done < <(git log --format='%s%n%b%x1e' "$intervalo")

case "$nivel" in
    3) nova="v$((maior + 1)).0.0" ;;
    2) nova="v$maior.$((menor + 1)).0" ;;
    1) nova="v$maior.$menor.$((patch + 1))" ;;
    *) echo "Nada a lançar desde $ultima (só docs/chore/refactor…)." >&2; exit 3 ;;
esac
echo "$nova"
if (( criar_tag )); then
    git tag -a "$nova" -m "Release $nova"
    echo "Tag $nova criada. Publique com: git push origin $nova" >&2
fi
