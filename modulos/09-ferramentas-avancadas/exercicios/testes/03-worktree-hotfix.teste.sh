# shellcheck shell=bash
# Testes do exercício 09.03 — Hotfix numa segunda pasta
montar() {
    git init -q app
    commitar relatorio.txt v1 "feat: relatório" app
    git -C app switch -q -c feature/login
    printf 'meio pronto\n' > app/login.txt
}
teste_worktree_existe() {
    montar; executar
    afirmar_contem "app-hotfix" "$(git -C app worktree list)"
}
teste_commit_na_branch_nova() {
    montar; executar
    afirmar_igual "fix: relatório de vendas" "$(git -C app log -1 --format=%s hotfix/relatorio 2>/dev/null)"
    afirmar_igual "feat: relatório" "$(git -C app log -1 --format=%s 'hotfix/relatorio~1')" "a branch deve sair da main"
}
teste_trabalho_original_intacto() {
    montar; executar
    afirmar_igual "feature/login" "$(git -C app branch --show-current)"
    afirmar_arquivo app/login.txt "o trabalho não commitado da feature não pode sumir"
}
