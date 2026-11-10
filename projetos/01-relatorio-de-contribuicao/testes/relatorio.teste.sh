# shellcheck shell=bash
# Testes do projeto 01 — relatorio.sh
montar() {
    git init -q repo
    GIT_AUTHOR_NAME=Ana commitar a.txt $'1\n2\n3' "feat: a" repo
    GIT_AUTHOR_NAME=Ana commitar a.txt $'1\n2' "fix: a" repo
    GIT_AUTHOR_NAME=Bia commitar b.txt 'x' "feat: b" repo
}
teste_tabela() {
    montar; executar repo
    afirmar_status 0
    afirmar_contem "| Ana | 2 | 3 | 1 | 1 |" "$SAIDA" "Ana: 2 commits, +3 −1, 1 arquivo distinto"
    afirmar_contem "| Bia | 1 | 1 | 0 | 1 |" "$SAIDA"
}
teste_ordenado_por_commits() {
    montar; executar repo
    afirmar_casa $'Ana.*\n.*Bia' "$SAIDA" "quem tem mais commits vem primeiro"
}
teste_filtro_de_data() {
    git init -q repo
    GIT_AUTHOR_DATE=2025-01-10T10:00 GIT_COMMITTER_DATE=2025-01-10T10:00 GIT_AUTHOR_NAME=Velho commitar v.txt 1 "chore: antigo" repo
    GIT_AUTHOR_NAME=Novo commitar n.txt 1 "chore: novo" repo
    executar repo --desde 2026-01-01
    afirmar_nao_contem "Velho" "$SAIDA"
}
