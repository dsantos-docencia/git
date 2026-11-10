# shellcheck shell=bash
# Testes do exercício 11.03 — Tirar o segredo do histórico
montar() {
    git init -q loja
    commitar app.py 'print(1)' "feat: app" loja
    printf 'AWS_KEY=AKIAABCDEFGHIJKLMNOP\n' > loja/.env
    commitar config.py 'X=1' "chore: config" loja
    git -C loja add .env && git -C loja commit -q --amend --no-edit
    git -C loja rm -q .env && git -C loja commit -q -m "chore: remove .env"
    git -C loja branch outra
}
teste_nenhum_commit_com_env() {
    montar; executar
    if git -C loja log --all --format=%H -- .env | grep -q .; then _falhar ".env ainda aparece em algum commit"; fi
    return 0
}
teste_preserva_o_resto() {
    montar; executar
    afirmar_igual "X=1" "$(git -C loja show main:config.py)"
    afirmar_igual "print(1)" "$(git -C loja show main:app.py)"
}
teste_todas_as_branches() {
    montar; executar
    git -C loja cat-file -e 'outra~1:.env' 2>/dev/null && _falhar "a branch 'outra' ainda tem o .env"
    [[ -z "$(git -C loja for-each-ref refs/original)" ]] || _falhar "apague o backup refs/original/*"
}
