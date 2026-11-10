# shellcheck shell=bash
# Testes do exercício 07.01 — Feature em cima da main atual
montar() {
    git init -q loja
    commitar app.txt base "feat: base" loja
    git -C loja switch -q -c feature/cupom
    commitar cupom.txt c1 "feat: modelo de cupom" loja
    commitar valida.txt c2 "feat: valida cupom" loja
    git -C loja switch -q main
    commitar fix.txt fix "fix: corrige total" loja
}
teste_linear() {
    montar; executar
    afirmar_igual "0" "$(git -C loja rev-list --merges --count main)" "rebase + ff não deixam commit de merge"
}
teste_ordem() {
    montar; executar
    afirmar_igual $'feat: valida cupom\nfeat: modelo de cupom\nfix: corrige total\nfeat: base' "$(git -C loja log --format=%s main)"
}
