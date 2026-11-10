# shellcheck shell=bash
# Testes do exercício 07.03 — Hotfix na release
montar() {
    git init -q loja
    commitar app.txt v1 "feat: versão 1" loja
    git -C loja branch release/1.x
    commitar tela.txt tela "feat: tela nova" loja
    commitar seguranca.txt fix "fix: falha de segurança no login" loja
}
teste_fix_na_release() {
    montar; executar
    afirmar_igual "fix: falha de segurança no login" "$(git -C loja log -1 --format=%s release/1.x)"
}
teste_anota_origem() {
    montar; executar
    afirmar_contem "cherry picked from commit $(git -C loja rev-parse main)" "$(git -C loja log -1 --format=%b release/1.x)"
}
teste_sem_tela_nova() {
    montar; executar
    git -C loja cat-file -e release/1.x:tela.txt 2>/dev/null && _falhar "a release não pode ter tela.txt"
    return 0
}
