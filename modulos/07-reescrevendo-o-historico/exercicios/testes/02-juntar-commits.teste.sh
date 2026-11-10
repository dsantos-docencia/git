# shellcheck shell=bash
# Testes do exercício 07.02 — Limpar a feature antes do PR
montar() {
    git init -q app
    commitar app.txt base "feat: base" app
    commitar cupom.txt 1 "feat: modelo de cupom" app
    commitar cupom.txt $'1\n2' "wip" app
    commitar regra.txt r "ajuste" app
    commitar teste.txt t "corrige teste" app
}
teste_um_commit() {
    montar; executar
    afirmar_igual $'feat: cupom de desconto\nfeat: base' "$(git -C app log --format=%s)"
}
teste_mesmo_conteudo() {
    montar
    arvore="$(git -C app rev-parse 'HEAD^{tree}')"
    executar
    afirmar_igual "$arvore" "$(git -C app rev-parse 'HEAD^{tree}')" "o conteúdo final não pode mudar"
}
