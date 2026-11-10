# shellcheck shell=bash
# Testes do exercício 03.02 — Desfazer um commit já publicado
montar() {
    git init -q app
    commitar loja.py 'v1' "feat: loja" app
    commitar cupom.py 'bug' "feat: cupom com bug" app
    commitar frete.py 'ok' "feat: frete" app
}
teste_cupom_removido() {
    montar; executar
    [[ ! -e app/cupom.py ]] || _falhar "cupom.py ainda existe"
    afirmar_igual "" "$(git -C app status --porcelain)" "a reversão deve estar commitada"
}
teste_historico_preservado() {
    montar; executar
    afirmar_igual "4" "$(git -C app rev-list --count HEAD)" "esperava os 3 commits originais + 1 de revert"
    afirmar_contem "feat: cupom com bug" "$(git -C app log --format=%s)" "o commit com bug deve continuar no histórico"
}
teste_ultimo_e_revert() {
    montar; executar
    afirmar_casa '^Revert "feat: cupom com bug"' "$(git -C app log -1 --format=%s)"
}
teste_frete_intacto() {
    montar; executar
    afirmar_arquivo app/frete.py "o revert não pode levar junto o commit seguinte"
}
