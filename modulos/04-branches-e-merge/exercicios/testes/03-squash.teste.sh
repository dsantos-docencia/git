# shellcheck shell=bash
# Testes do exercício 04.03 — Integrar com squash
montar() {
    git init -q loja
    commitar app.txt base "feat: base" loja
    git -C loja switch -q -c feature/login
    for n in 1 2 3; do commitar "login$n.txt" "$n" "wip: login $n" loja; done
    git -C loja switch -q main
}
teste_um_commit_novo() {
    montar; executar
    afirmar_igual $'feat: login completo\nfeat: base' "$(git -C loja log --format=%s main)"
}
teste_trouxe_os_arquivos() {
    montar; executar
    for n in 1 2 3; do afirmar_arquivo "loja/login$n.txt"; done
}
teste_branch_apagada() {
    montar; executar
    git -C loja show-ref -q --verify refs/heads/feature/login && _falhar "apague a branch feature/login"
    return 0
}
