# shellcheck shell=bash
# Testes do exercício 03.03 — Branch apagada por engano
montar() {
    git init -q app
    commitar a.txt '1' "feat: base" app
    git -C app switch -q -c experimento
    commitar ideia.txt 'ideia' "exp: ideia ousada" app
    git -C app switch -q main
    git -C app branch -q -D experimento
}
teste_branch_existe() {
    montar; executar
    git -C app show-ref --verify -q refs/heads/experimento || _falhar "a branch experimento não existe"
}
teste_aponta_para_o_commit_certo() {
    montar; executar
    afirmar_igual "exp: ideia ousada" "$(git -C app log -1 --format=%s experimento 2>/dev/null)"
}
teste_main_intacta() {
    montar; executar
    afirmar_igual "feat: base" "$(git -C app log -1 --format=%s main)" "a main não deveria mudar"
}
