# shellcheck shell=bash
# Testes de scripts/hooks/commit-msg.sh
msg() { printf '%s\n' "$1" > MSG; executar MSG; }
teste_aceita_padrao() { msg "feat(login): adiciona SSO"; afirmar_status 0; }
teste_aceita_breaking() { msg "refactor!: troca formato do token"; afirmar_status 0; }
teste_aceita_merge() { msg "Merge branch 'feature' into main"; afirmar_status 0; }
teste_recusa_wip() { msg "wip"; afirmar_status_diferente_de_zero; afirmar_contem "Conventional Commits" "$ERRO"; }
teste_recusa_resumo_longo() { msg "feat: $(printf 'x%.0s' {1..80})"; afirmar_status_diferente_de_zero; }
