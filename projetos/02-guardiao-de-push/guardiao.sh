#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · Projeto 02 · Guardião de push (hook pre-push)
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  INSTALAR  cp guardiao.sh .githooks/pre-push && git config core.hooksPath .githooks
#  BLOQUEIA  1. push direto para main/master (exceto com PERMITIR_PUSH_MAIN=1)
#            2. apagar main/master no servidor
#            3. push que REESCREVE histórico (não fast-forward) em qualquer branch
#  COMO      o Git chama o hook com $1=remoto $2=url e, na entrada padrão, uma linha
#            por referência:  <ref local> <sha local> <ref remota> <sha remoto>
#  MÓDULOS   06 (push, fast-forward), 07 (reescrita), 10 (objetos, merge-base), 11 (hooks)
# ============================================================================
set -euo pipefail

remoto="${1:-?}"
protegidas_regex='^refs/heads/(main|master)$'
zero_regex='^0+$'          # sha "vazio": a ref não existe (criação ou remoção)
erros=0

recusar() { printf '✘ [guardião] %s\n' "$*" >&2; erros=1; }

# (a ref local não é usada nas regras, mas faz parte da linha: lida em "_")
while read -r _ sha_local ref_remota sha_remoto; do
    [[ -z "${ref_remota:-}" ]] && continue
    nome="${ref_remota#refs/heads/}"

    if [[ "$ref_remota" =~ $protegidas_regex ]]; then
        if [[ "$sha_local" =~ $zero_regex ]]; then
            recusar "apagar '$nome' no $remoto não é permitido."
            continue
        fi
        if [[ "${PERMITIR_PUSH_MAIN:-0}" != "1" ]]; then
            recusar "push direto para '$nome'. Abra um Pull/Merge Request (ou, em emergência, PERMITIR_PUSH_MAIN=1)."
            continue
        fi
    fi

    # Atualização de branch existente: precisa ser avanço rápido
    if [[ ! "$sha_remoto" =~ $zero_regex && ! "$sha_local" =~ $zero_regex ]]; then
        if ! git cat-file -e "$sha_remoto^{commit}" 2>/dev/null; then
            recusar "'$nome' no $remoto tem commits que você não baixou. Rode git fetch e integre antes."
        elif ! git merge-base --is-ancestor "$sha_remoto" "$sha_local"; then
            recusar "push em '$nome' reescreveria o histórico (force push). Integre em vez de sobrescrever."
        fi
    fi
done

exit "$erros"
