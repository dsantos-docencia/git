# shellcheck shell=bash
# Testes do exercício 00.03 — De onde vem esta configuração?
teste_escopo_e_valor() {
    executar
    afirmar_igual $'local\tnano' "$SAIDA" "esperava o escopo, um TAB e o valor"
}
teste_gravou_no_local() {
    executar
    afirmar_igual "nano" "$(git -C projeto config --local --get core.editor)"
}
