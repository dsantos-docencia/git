# shellcheck shell=bash
# Testes do exercício 06.03 — Sincronizar o fork
montar() {
    git init -q --bare original.git
    git clone -q original.git mant 2>/dev/null
    commitar README.md '# Lib' "docs: readme" mant
    git -C mant push -q -u origin main
    git clone -q --bare original.git fork.git
    git clone -q fork.git voce
    commitar novo.txt x "feat: novidade" mant
    git -C mant push -q
}
teste_remoto_upstream() {
    montar; executar
    afirmar_igual "../original.git" "$(git -C voce remote get-url upstream 2>/dev/null)"
}
teste_fork_atualizado() {
    montar; executar
    afirmar_igual "feat: novidade" "$(git -C fork.git log -1 --format=%s main)" "a novidade deve chegar ao SEU fork"
}
teste_origin_continua_o_fork() {
    montar; executar
    afirmar_contem "fork.git" "$(git -C voce remote get-url origin)"
}
