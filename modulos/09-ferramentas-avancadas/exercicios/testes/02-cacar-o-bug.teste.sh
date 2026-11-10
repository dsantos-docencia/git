# shellcheck shell=bash
# Testes do exercício 09.02 — Caçar o commit culpado
montar() {
    git init -q loja
    for n in $(seq 1 30); do
        if (( n < 19 )); then op='+'; else op='-'; fi
        commitar relatorio.txt "total = a $op b" "chore: alteração $n" loja
        (( n == 1 )) && git -C loja tag v1.0
    done
}
teste_culpado() {
    montar; executar
    afirmar_igual "chore: alteração 19" "$SAIDA"
}
teste_bisect_finalizado() {
    montar; executar
    afirmar_igual "main" "$(git -C loja branch --show-current)" "termine com git bisect reset (de volta à main)"
    [[ ! -e loja/.git/BISECT_LOG ]] || _falhar "o bisect ainda está em andamento"
}
