# shellcheck shell=bash
# Testes do exercício 03.01 — Mensagem ruim no último commit
montar() {
    git init -q app
    commitar README.md '# App' "docs: readme" app
    commitar login.py 'def login(): pass' "wip" app
}
teste_mensagem_trocada() {
    montar; executar
    afirmar_igual "feat: adiciona login" "$(git -C app log -1 --format=%s)"
}
teste_mesma_quantidade_de_commits() {
    montar; executar
    afirmar_igual "2" "$(git -C app rev-list --count HEAD)" "amend substitui o commit — não cria outro"
}
teste_conteudo_inalterado() {
    montar
    arvore_antes="$(git -C app rev-parse 'HEAD^{tree}')"
    executar
    afirmar_igual "$arvore_antes" "$(git -C app rev-parse 'HEAD^{tree}')" "os arquivos do commit não deveriam mudar"
}
