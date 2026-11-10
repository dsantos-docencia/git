#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · scripts/dia-a-dia/limpar-branches-mescladas.sh
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  O QUE FAZ  Lista (e, com --aplicar, apaga) branches LOCAIS já mescladas na
#             branch principal. Nunca apaga a principal nem a branch atual.
#  USO        limpar-branches-mescladas.sh [--base main] [--aplicar]
#  POR QUÊ    Depois de meses, 'git branch' vira uma lista de 80 itens. Por
#             padrão o script só SIMULA: apagar exige --aplicar (seguro).
# ============================================================================
set -euo pipefail

base="main"; aplicar=0
while (( $# )); do
    case "$1" in
        --base)    base="${2:?informe a branch base}"; shift 2 ;;
        --aplicar) aplicar=1; shift ;;
        -h|--help) sed -n '5,9p' "$0"; exit 0 ;;
        *) echo "opção desconhecida: $1" >&2; exit 2 ;;
    esac
done

git rev-parse --git-dir >/dev/null 2>&1 || { echo "não é um repositório Git" >&2; exit 1; }
git show-ref --verify -q "refs/heads/$base" || { echo "branch base '$base' não existe" >&2; exit 1; }
atual="$(git branch --show-current)"

# for-each-ref --merged: branches cujo topo já está contido na base (saída estável para scripts)
mapfile -t candidatas < <(git for-each-ref --merged="$base" --format='%(refname:short)' refs/heads \
                          | grep -vxF -e "$base" -e "$atual" || true)

if (( ${#candidatas[@]} == 0 )); then
    echo "Nenhuma branch mesclada em $base para limpar."
    exit 0
fi
printf 'Branches mescladas em %s:\n' "$base"
printf '  %s\n' "${candidatas[@]}"
if (( aplicar )); then
    git branch -d -- "${candidatas[@]}"     # -d (não -D): o Git recusa se não estiver mesclada
    echo "Removidas: ${#candidatas[@]}"
else
    echo "(simulação — rode com --aplicar para apagar)"
fi
