# shellcheck shell=bash
# Testes de scripts/release/proxima-versao.sh
base() { git init -q repo && cd repo && commitar a 1 "feat: inicial" && git tag -a v1.2.3 -m v1.2.3; }
teste_fix_gera_patch() {
    base; commitar b 1 "fix: corrige arredondamento"; executar
    afirmar_igual "v1.2.4" "$SAIDA"
}
teste_feat_gera_minor() {
    base; commitar b 1 "fix: x"; commitar c 1 "feat(api): novo endpoint"; executar
    afirmar_igual "v1.3.0" "$SAIDA"
}
teste_breaking_gera_major() {
    base; commitar b 1 "feat!: remove endpoint antigo"; executar
    afirmar_igual "v2.0.0" "$SAIDA"
}
teste_breaking_no_corpo() {
    base; echo x > c; git add c; git commit -q -m "refactor: muda API" -m "BREAKING CHANGE: campo renomeado"; executar
    afirmar_igual "v2.0.0" "$SAIDA"
}
teste_so_docs_nao_lanca() {
    base; commitar b 1 "docs: readme"; executar
    afirmar_status 3
}
teste_cria_tag() {
    base; commitar b 1 "fix: y"; executar --tag
    git rev-parse -q --verify refs/tags/v1.2.4 >/dev/null || _falhar "a tag v1.2.4 deveria existir"
}
teste_feat_no_meio_do_historico() {
    base; commitar b 1 "fix: a"; commitar c 1 "feat(pedidos): frete"; commitar d 1 "docs: readme"; executar
    afirmar_igual "v1.3.0" "$SAIDA" "o feat não é o último commit, mas define a versão"
}
