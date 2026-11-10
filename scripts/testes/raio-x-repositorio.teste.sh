# shellcheck shell=bash
# Testes de scripts/auditoria/raio-x-repositorio.sh
teste_relatorio_basico() {
    git init -q repo
    commitar a.txt 1 "feat: a" repo; commitar grande.txt "$(printf 'z%.0s' {1..5000})" "feat: grande" repo
    executar repo
    afirmar_status 0
    afirmar_contem "Commits (HEAD): 2" "$SAIDA"
    afirmar_contem "grande.txt" "$SAIDA" "o maior arquivo do histórico deve aparecer"
}
