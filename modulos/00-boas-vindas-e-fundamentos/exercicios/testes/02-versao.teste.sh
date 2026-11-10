# shellcheck shell=bash
# Testes do exercício 00.02 — Só o número da versão
teste_formato() {
    executar
    afirmar_casa '^[0-9]+\.[0-9]+\.[0-9]+$' "$SAIDA" "só X.Y.Z, sem 'git version' nem sufixos"
}
teste_e_a_versao_instalada() {
    executar
    afirmar_contem "$SAIDA" "$(git --version)" "o número deve ser o da versão instalada"
}
