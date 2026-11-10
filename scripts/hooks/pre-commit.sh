#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · scripts/hooks/pre-commit.sh
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  O QUE FAZ  Hook 'pre-commit': bloqueia o commit se a área de preparação tiver
#             arquivos de segredo (.env, *.pem, *.key), padrões de chave/token,
#             ou arquivos maiores que LIMITE_KB (padrão 5120 KB).
# ============================================================================
set -euo pipefail

LIMITE_KB="${LIMITE_KB:-5120}"
erros=0

# Arquivos preparados (Adicionados, Copiados, Modificados, Renomeados); -z para nomes com espaço
while IFS= read -r -d '' arq; do
    case "$arq" in
        .env|*/.env|*.pem|*.key|id_rsa|*/id_rsa|id_ed25519|*/id_ed25519)
            echo "✘ arquivo de segredo na preparação: $arq" >&2; erros=1 ;;
    esac
    # tamanho da versão PREPARADA (:arquivo), não do disco
    tamanho="$(git cat-file -s ":$arq" 2>/dev/null || echo 0)"
    if (( tamanho > LIMITE_KB * 1024 )); then
        echo "✘ $arq tem $((tamanho / 1024)) KB (limite ${LIMITE_KB} KB) — use Git LFS" >&2; erros=1
    fi
done < <(git diff --cached --name-only --diff-filter=ACMR -z)

# Conteúdo preparado com cara de segredo
if git diff --cached -U0 | grep -E '^\+' | grep -qE 'AKIA[0-9A-Z]{16}|-----BEGIN ([A-Z]+ )?PRIVATE KEY-----|gh[pousr]_[A-Za-z0-9]{36,}|glpat-[A-Za-z0-9_-]{20,}'; then
    echo "✘ o diff preparado contém algo com formato de chave ou token" >&2; erros=1
fi

if (( erros )); then
    echo "Commit bloqueado. Corrija, ou (se tiver certeza) use git commit --no-verify." >&2
    exit 1
fi
