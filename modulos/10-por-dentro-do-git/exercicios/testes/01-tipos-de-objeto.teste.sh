# shellcheck shell=bash
# Testes do exercício 10.01 — Que objeto é este?
montar() { git init -q obj; commitar README.md 'olá' "docs: readme" obj; git -C obj tag -a v1.0 -m v1.0; }
teste_tipos() {
    montar; executar
    afirmar_igual $'commit\ntree\nblob\ntag' "$SAIDA"
}
teste_tag_leve_e_commit() {
    montar; git -C obj tag -d v1.0 >/dev/null; git -C obj tag v1.0; executar
    afirmar_igual $'commit\ntree\nblob\ncommit' "$SAIDA" "com tag LEVE, v1.0 aponta direto para um commit"
}
