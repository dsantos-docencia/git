#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · Projeto 01 · Relatório de contribuição
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  USO     relatorio.sh [pasta-do-repo] [--desde "2026-01-01"] [--ate "2026-06-30"]
#  SAÍDA   tabela Markdown por autor: commits, linhas adicionadas/removidas e
#          arquivos distintos, ordenada por commits (merges ignorados)
#  MÓDULOS 02 (log, --numstat, --since), 10 (formatos estáveis para scripts)
# ============================================================================
set -euo pipefail

repo="."; filtros=()
while (( $# )); do
    case "$1" in
        --desde) filtros+=("--since=${2:?}"); shift 2 ;;
        --ate)   filtros+=("--until=${2:?}"); shift 2 ;;
        -h|--help) sed -n '5,9p' "$0"; exit 0 ;;
        *) repo="$1"; shift ;;
    esac
done
git -C "$repo" rev-parse --git-dir >/dev/null 2>&1 || { echo "não é um repositório Git: $repo" >&2; exit 1; }

# Formato: uma linha "@@autor" por commit, seguida das linhas do --numstat (adições, remoções, arquivo).
# Binários aparecem como "-  -  arquivo" e contam como 0 linhas.
git -C "$repo" log --no-merges "${filtros[@]}" --format='@@%aN' --numstat \
| awk -F'\t' '
    /^@@/        { autor = substr($0, 3); commits[autor]++; next }
    NF == 3      { if ($1 != "-") mais[autor] += $1
                   if ($2 != "-") menos[autor] += $2
                   if (!((autor, $3) in visto)) { visto[autor, $3] = 1; arquivos[autor]++ } }
    END {
        print "| Autor | Commits | + linhas | − linhas | Arquivos |"
        print "|---|---:|---:|---:|---:|"
        for (a in commits) printf "%d\t| %s | %d | %d | %d | %d |\n", commits[a], a, commits[a], mais[a]+0, menos[a]+0, arquivos[a]+0
    }' \
| { IFS= read -r cab1; IFS= read -r cab2; printf '%s\n%s\n' "$cab1" "$cab2"; sort -t$'\t' -k1,1nr -k2 | cut -f2-; }
