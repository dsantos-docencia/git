# shellcheck shell=bash
# Testes do exercício 05.03 — Desistir com segurança
# Repositório "loja" com um merge EM ANDAMENTO e conflito no config.ini:
#   ancestral TAXA=0.12 · main: TAXA=0.15 e FRETE=12 · feature/imposto: TAXA=0.18 e novo arquivo nf.txt
montar_conflito() {
    git init -q loja
    commitar config.ini $'MOEDA=BRL\nTAXA=0.12\nFRETE=10' "feat: config" loja
    git -C loja switch -q -c feature/imposto
    commitar config.ini $'MOEDA=BRL\nTAXA=0.18\nFRETE=10' "feat: imposto 18%" loja
    commitar nf.txt 'nota fiscal' "feat: nota fiscal" loja
    git -C loja switch -q main
    commitar config.ini $'MOEDA=BRL\nTAXA=0.15\nFRETE=12' "feat: imposto 15% e frete 12" loja
}

teste_mesmo_commit() {
    montar_conflito
    antes="$(git -C loja rev-parse HEAD)"
    executar
    afirmar_igual "$antes" "$(git -C loja rev-parse HEAD)"
}
teste_sem_merge_em_andamento() {
    montar_conflito; executar
    [[ ! -e loja/.git/MERGE_HEAD ]] || _falhar "ainda há um merge em andamento (MERGE_HEAD existe)"
    afirmar_igual "" "$(git -C loja status --porcelain)"
    afirmar_contem "TAXA=0.15" "$(cat loja/config.ini)"
}
