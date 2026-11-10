#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · scripts/hooks/commit-msg.sh
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  O QUE FAZ  Hook 'commit-msg': recusa mensagens fora do Conventional Commits.
#  INSTALAR   bash scripts/hooks/instalar-hooks.sh   (no repositório desejado)
#  ARGUMENTO  o Git passa $1 = caminho do arquivo com a mensagem
# ============================================================================
set -euo pipefail

arquivo="${1:?o Git passa o arquivo da mensagem como 1º argumento}"
primeira="$(grep -v '^#' "$arquivo" | head -n 1)"

# Merges e reverts gerados pelo próprio Git passam direto
[[ "$primeira" =~ ^(Merge|Revert|fixup!|squash!) ]] && exit 0

padrao='^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\([a-z0-9._/-]+\))?!?: .{3,}'
if [[ ! "$primeira" =~ $padrao ]]; then
    cat >&2 <<MSG
✘ Mensagem fora do padrão Conventional Commits:
    "$primeira"
  Formato: tipo(escopo opcional): descrição
  Tipos:   feat fix docs style refactor perf test build ci chore revert
  Exemplo: feat(pedidos): calcula frete por CEP
  (Para pular em emergência: git commit --no-verify)
MSG
    exit 1
fi
if (( ${#primeira} > 72 )); then
    echo "✘ Resumo com ${#primeira} caracteres — use até 72 (ideal: 50)." >&2
    exit 1
fi
