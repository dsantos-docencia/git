# shellcheck shell=bash
# Testes do projeto 03 — release.sh
montar() {
    git init -q --bare servidor.git
    git clone -q servidor.git app 2>/dev/null
    commitar app.py 1 "feat: inicial" app
    git -C app tag -a v1.0.0 -m v1.0.0
    commitar frete.py 1 "feat(pedidos): frete por CEP" app
    commitar fix.py 1 "fix: arredondamento" app
    git -C app push -q -u origin main --follow-tags
    cd app || exit 1
}
teste_release_local() {
    montar; executar
    afirmar_status 0
    afirmar_igual "chore(release): v1.1.0" "$(git log -1 --format=%s)"
    afirmar_igual "tag" "$(git cat-file -t v1.1.0 2>/dev/null)"
    afirmar_contem "## v1.1.0" "$(sed -n 1p CHANGELOG.md)"
    afirmar_contem "frete por CEP" "$(cat CHANGELOG.md)"
}
teste_publica() {
    montar; executar --publicar
    git -C ../servidor.git rev-parse -q --verify refs/tags/v1.1.0 >/dev/null || _falhar "a tag deveria estar no servidor"
}
teste_recusa_area_suja() {
    montar; echo x >> app.py; executar
    afirmar_status 1; afirmar_contem "não commitadas" "$ERRO"
}
teste_recusa_desatualizado() {
    montar
    git clone -q ../servidor.git ../outro; commitar z.py 1 "feat: z" ../outro; git -C ../outro push -q
    executar
    afirmar_status 1; afirmar_contem "atrás" "$ERRO"
}
teste_nada_a_lancar() {
    montar
    git tag -a v1.1.0 -m v1.1.0; commitar README.md x "docs: readme"; git push -q
    executar
    afirmar_status 3
}
