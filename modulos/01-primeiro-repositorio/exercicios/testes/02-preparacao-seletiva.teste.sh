# shellcheck shell=bash
# Testes do exercício 01.02 — Preparação seletiva
teste_status_exato() {
    executar
    afirmar_igual $'M  a.txt\n?? b.txt' "$(git -C projeto status --porcelain)"
}
teste_um_commit_so_com_a() {
    executar
    afirmar_igual "a.txt" "$(git -C projeto ls-tree --name-only HEAD)" "o commit deve conter apenas a.txt"
    afirmar_igual "versão 1" "$(git -C projeto show HEAD:a.txt)"
}
teste_preparado_e_versao_2() {
    executar
    # ':a.txt' = a versão que está NA ÁREA DE PREPARAÇÃO (index)
    afirmar_igual "versão 2" "$(git -C projeto show :a.txt)"
}
