# shellcheck shell=bash
# Testes do exercício 01.01 — Primeiro commit
teste_um_commit() {
    executar
    afirmar_igual "1" "$(git -C projeto rev-list --count HEAD 2>/dev/null)" "deve haver exatamente 1 commit"
}
teste_mensagem() {
    executar
    afirmar_igual "docs: adiciona README" "$(git -C projeto log -1 --format=%s)"
}
teste_conteudo_commitado() {
    executar
    # show HEAD:arquivo lê o conteúdo DO COMMIT, não do disco
    afirmar_igual "# Projeto" "$(git -C projeto show HEAD:README.md 2>/dev/null)" "README.md no commit com o conteúdo exato"
}
teste_arvore_limpa() {
    executar
    afirmar_igual "" "$(git -C projeto status --porcelain)" "não deve sobrar nada sem commit"
}
