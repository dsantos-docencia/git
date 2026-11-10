# shellcheck shell=bash
# Testes do exercício 04.02 — Merge de três vias registrado
montar() {
    git init -q loja
    commitar app.txt base "feat: base" loja
    git -C loja branch feature/cupom
    commitar hotfix.txt fix "fix: hotfix" loja
    git -C loja switch -q feature/cupom
    commitar cupom.txt cupom "feat: cupom" loja
    git -C loja switch -q main
}
teste_commit_de_merge() {
    montar; executar
    afirmar_igual "Merge: cupom de desconto" "$(git -C loja log -1 --format=%s main)"
    afirmar_igual "2" "$(git -C loja log -1 --format=%p main | wc -w | tr -d ' ')" "um commit de merge tem 2 pais"
}
teste_traz_os_dois_lados() {
    montar; executar
    afirmar_arquivo loja/cupom.txt; afirmar_arquivo loja/hotfix.txt
    afirmar_igual "" "$(git -C loja status --porcelain)" "o merge deve estar concluído"
}
