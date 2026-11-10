# shellcheck shell=bash
# Testes de scripts/dia-a-dia/sincronizar-fork.sh
montar() {
    git init -q original; commitar a 1 "feat: a" original
    git clone -q --bare original fork.git
    git clone -q fork.git meu && { cd meu || exit 1; }
    git remote add upstream ../original
    commitar b 1 "feat: novidade do original" ../original
}
teste_sincroniza_e_publica() {
    montar; executar
    afirmar_status 0
    afirmar_igual "feat: novidade do original" "$(git log -1 --format=%s main)"
    afirmar_igual "feat: novidade do original" "$(git -C ../fork.git log -1 --format=%s main)" "deve enviar ao origin (o fork)"
}
teste_sem_upstream() {
    git init -q x && cd x && commitar a 1 "feat: a"; executar
    afirmar_status_diferente_de_zero; afirmar_contem "upstream" "$ERRO"
}
