# shellcheck shell=bash
# Testes do exercício 08.02 — Qual é a última versão?
montar() {
    git init -q lib
    commitar a 1 "feat: base" lib
    for t in v1.2.0 v1.9.3 v1.10.0 v1.10.1 nightly; do git -C lib tag "$t"; done
}
teste_maior_versao() {
    montar; executar
    afirmar_igual "v1.10.1" "$SAIDA"
}
teste_nao_e_fixo() {
    montar; git -C lib tag v2.0.0; executar
    afirmar_igual "v2.0.0" "$SAIDA" "a resposta deve vir do repositório"
}
