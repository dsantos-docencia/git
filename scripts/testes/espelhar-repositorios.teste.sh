# shellcheck shell=bash
# Testes de scripts/backup/espelhar-repositorios.sh
teste_espelha_e_atualiza() {
    git init -q origem; commitar a 1 "feat: a" origem; git -C origem tag v1
    printf '# comentário\n%s\n' "$PWD/origem" > lista.txt
    executar lista.txt bkp
    afirmar_status 0
    afirmar_igual "true" "$(git -C bkp/origem.git rev-parse --is-bare-repository)"
    git -C bkp/origem.git rev-parse -q --verify refs/tags/v1 >/dev/null || _falhar "as tags devem ir para o espelho"
    commitar b 1 "feat: b" origem
    executar lista.txt bkp
    afirmar_igual "2" "$(git -C bkp/origem.git rev-list --count main)" "a 2ª execução deve atualizar o espelho"
}
