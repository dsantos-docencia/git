# shellcheck shell=bash
# Testes do exercício 04.01 — Feature com avanço rápido
teste_main_com_dois_commits() {
    executar
    afirmar_igual $'feat: frete\nfeat: base' "$(git -C loja log --format=%s main)"
}
teste_sem_commit_de_merge() {
    executar
    afirmar_igual "0" "$(git -C loja rev-list --merges --count main)" "avanço rápido não cria commit de merge"
}
teste_branch_apagada() {
    executar
    git -C loja show-ref -q --verify refs/heads/feature/frete && _falhar "a branch feature/frete deveria ter sido apagada"
    afirmar_igual "main" "$(git -C loja branch --show-current)" "termine na main"
}
