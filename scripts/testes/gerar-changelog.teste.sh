# shellcheck shell=bash
# Testes de scripts/release/gerar-changelog.sh
teste_agrupa_por_tipo() {
    git init -q repo && { cd repo || exit 1; }
    commitar a 1 "chore: inicial"; git tag v1.0.0
    commitar b 1 "feat(pedidos): calcula frete"
    commitar c 1 "fix: corrige total"
    commitar d 1 "commit sem padrão"
    executar
    afirmar_contem "### ✨ Novidades" "$SAIDA"
    afirmar_contem "**pedidos:** calcula frete" "$SAIDA"
    afirmar_contem "### 🐛 Correções" "$SAIDA"
    afirmar_contem "- commit sem padrão" "$SAIDA"
    afirmar_nao_contem "chore: inicial" "$SAIDA" "commits anteriores à tag não entram"
}
