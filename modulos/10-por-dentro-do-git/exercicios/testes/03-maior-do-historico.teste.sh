# shellcheck shell=bash
# Testes do exercício 10.03 — O maior arquivo de todos os tempos
montar() {
    git init -q app
    commitar app.py 'print(1)' "feat: app" app
    commitar dump.sql "$(printf 'x%.0s' {1..5000})" "chore: dump do banco por engano" app
    git -C app rm -q dump.sql && git -C app commit -q -m "chore: remove dump"
    commitar README.md "$(printf 'y%.0s' {1..300})" "docs: readme" app
}
teste_acha_o_arquivo_apagado() {
    montar; executar
    afirmar_igual "dump.sql" "$SAIDA"
}
