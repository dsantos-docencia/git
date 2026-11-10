#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · scripts/backup/espelhar-repositorios.sh
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  O QUE FAZ  Backup fiel (todas as branches, tags e refs) de uma lista de
#             repositórios remotos, com 'git clone --mirror'. Na segunda
#             execução, só atualiza (git remote update --prune).
#  USO        espelhar-repositorios.sh lista.txt [pasta-destino]
#  LISTA      uma URL por linha; linhas vazias e começando com # são ignoradas
#  RESTAURAR  git clone pasta/projeto.git  ·  ou  git push --mirror <url-nova>
# ============================================================================
set -euo pipefail

lista="${1:?uso: espelhar-repositorios.sh lista.txt [pasta-destino]}"
destino="${2:-espelhos}"
mkdir -p "$destino"
ok=0 falhas=0
while IFS= read -r url || [[ -n "$url" ]]; do
    url="${url%%#*}"; url="${url//[[:space:]]/}"
    [[ -z "$url" ]] && continue
    nome="$(basename "$url" .git).git"
    alvo="$destino/$nome"
    if [[ -d "$alvo" ]]; then
        echo "↻ atualizando $nome"
        if git -C "$alvo" remote update --prune >/dev/null 2>&1; then ((++ok)); else echo "  ✘ falhou: $url" >&2; ((++falhas)); fi
    else
        echo "⬇ espelhando $nome"
        if git clone -q --mirror "$url" "$alvo"; then ((++ok)); else echo "  ✘ falhou: $url" >&2; ((++falhas)); fi
    fi
done < "$lista"
echo "Concluído: $ok ok, $falhas falha(s). Destino: $destino"
(( falhas == 0 ))
