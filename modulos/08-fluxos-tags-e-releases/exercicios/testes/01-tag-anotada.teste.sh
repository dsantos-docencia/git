# shellcheck shell=bash
# Testes do exercício 08.01 — Marcar uma release antiga
montar() {
    git init -q lib
    commitar a 1 "feat: base" lib
    commitar b 1 "fix: corrige arredondamento" lib
    commitar c 1 "feat: novidade" lib
}
teste_tag_anotada() {
    montar; executar
    afirmar_igual "tag" "$(git -C lib cat-file -t v1.3.1 2>/dev/null)" "a tag deve ser ANOTADA (git tag -a)"
}
teste_aponta_para_o_fix() {
    montar; executar
    afirmar_igual "fix: corrige arredondamento" "$(git -C lib log -1 --format=%s 'v1.3.1^{commit}' 2>/dev/null)"
}
teste_mensagem() {
    montar; executar
    afirmar_igual "Release 1.3.1" "$(git -C lib tag -l --format='%(contents:subject)' v1.3.1)"
}
