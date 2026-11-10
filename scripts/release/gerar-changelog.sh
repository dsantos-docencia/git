#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · scripts/release/gerar-changelog.sh
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  O QUE FAZ  Gera um CHANGELOG em Markdown, agrupando os commits (Conventional
#             Commits) desde a última tag — ou entre duas referências.
#  USO        gerar-changelog.sh [de] [ate]     (padrão: última tag .. HEAD)
#  EXEMPLO    gerar-changelog.sh v1.2.0 v1.3.0 > notas-da-versao.md
# ============================================================================
set -euo pipefail

de="${1:-$(git describe --tags --abbrev=0 2>/dev/null || true)}"
ate="${2:-HEAD}"
intervalo="$ate"; [[ -n "$de" ]] && intervalo="$de..$ate"

declare -A titulos=( [feat]="✨ Novidades" [fix]="🐛 Correções" [perf]="⚡ Desempenho"
                     [docs]="📝 Documentação" [refactor]="♻️ Refatoração" [test]="🧪 Testes" [outros]="🔧 Outros" )
ordem=(feat fix perf docs refactor test outros)
declare -A grupos=()

while IFS=$'\t' read -r hash assunto; do
    if [[ "$assunto" =~ ^([a-z]+)(\((.+)\))?(!)?:[[:space:]]*(.+)$ ]]; then
        tipo="${BASH_REMATCH[1]}" escopo="${BASH_REMATCH[3]}" quebra="${BASH_REMATCH[4]}" texto="${BASH_REMATCH[5]}"
        [[ -n "${titulos[$tipo]:-}" ]] || tipo="outros"
        linha="- ${quebra:+**BREAKING** }${escopo:+**$escopo:** }$texto (\`$hash\`)"
    else
        tipo="outros"; linha="- $assunto (\`$hash\`)"
    fi
    grupos[$tipo]+="$linha"$'\n'
done < <(git log --no-merges --format='%h%x09%s' "$intervalo")

printf '## %s\n\n_%s_\n' "${ate}" "$(git log -1 --format=%ad --date=short "$ate")"
# shellcheck disable=SC2016  # crases são Markdown, não expansão
[[ -n "$de" ]] && printf '\nAlterações desde `%s`.\n' "$de"
for t in "${ordem[@]}"; do
    [[ -n "${grupos[$t]:-}" ]] || continue
    printf '\n### %s\n\n%s' "${titulos[$t]}" "${grupos[$t]}"
done
