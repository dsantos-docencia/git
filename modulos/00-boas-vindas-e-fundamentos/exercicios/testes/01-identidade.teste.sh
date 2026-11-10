# shellcheck shell=bash
# Testes do exercício 00.01 — Identidade local
teste_repositorio_existe() {
    executar
    afirmar_diretorio projeto/.git "a pasta projeto não é um repositório (falta git init?)"
}
teste_branch_inicial_main() {
    executar
    afirmar_igual "refs/heads/main" "$(git -C projeto symbolic-ref HEAD 2>/dev/null)" "a branch inicial deve ser main"
}
teste_nome_local() {
    executar
    afirmar_igual "Aluno Git" "$(git -C projeto config --local --get user.name)" "user.name no nível LOCAL"
}
teste_email_local() {
    executar
    afirmar_igual "aluno@curso.dev" "$(git -C projeto config --local --get user.email)" "user.email no nível LOCAL"
}
