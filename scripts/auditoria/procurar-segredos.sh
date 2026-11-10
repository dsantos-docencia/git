#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · scripts/auditoria/procurar-segredos.sh
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  O QUE FAZ  Procura padrões de segredos (chaves AWS, chaves privadas, tokens de
#             GitHub/GitLab, senhas em atribuições) em TODO o histórico.
#  USO        procurar-segredos.sh [pasta-do-repo]
#  SAÍDA      0 = nada encontrado · 1 = possíveis segredos (lista commit:arquivo)
#  NOTA       Didático e conservador. Para uso sério, use o Gitleaks
#             (https://github.com/gitleaks/gitleaks) e a proteção da plataforma.
# ============================================================================
set -euo pipefail

cd "${1:-.}"
git rev-parse --git-dir >/dev/null 2>&1 || { echo "não é um repositório Git" >&2; exit 1; }

# Padrões (regex estendida). Cada um com um nome legível.
declare -A padroes=(
    [chave-aws]='AKIA[0-9A-Z]{16}'
    [chave-privada]='-----BEGIN ([A-Z]+ )?PRIVATE KEY-----'
    [token-github]='gh[pousr]_[A-Za-z0-9]{36,}'
    [token-gitlab]='glpat-[A-Za-z0-9_-]{20,}'
    [senha-atribuida]='(senha|password|passwd|secret)[[:space:]]*[:=][[:space:]]*["'"'"']?[^[:space:]"'"'"']{6,}'
)

achou=0
# Percorre cada commit e usa git grep nele (busca no conteúdo daquela versão)
mapfile -t commits < <(git rev-list --all)
for nome in "${!padroes[@]}"; do
    resultado="$(git grep -I -l -i -E -e "${padroes[$nome]}" "${commits[@]}" 2>/dev/null | sort -u || true)"
    if [[ -n "$resultado" ]]; then
        achou=1
        printf '⚠ %s:\n' "$nome"
        # saída do git grep: <commit>:<arquivo> — mostramos o hash curto
        while IFS=: read -r c arq; do printf '    %s  %s\n' "${c:0:8}" "$arq"; done <<<"$resultado"
    fi
done
if (( achou )); then
    echo "Possíveis segredos encontrados. Troque as credenciais e limpe o histórico (git filter-repo)."
    exit 1
fi
echo "Nenhum padrão de segredo encontrado em ${#commits[@]} commit(s)."
