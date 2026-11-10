# shellcheck shell=bash
# Testes do exercício 05.01 — Resolver à mão
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

teste_conteudo_final() {
    montar_conflito; executar
    afirmar_igual $'MOEDA=BRL\nTAXA=0.18\nFRETE=12' "$(git -C loja show HEAD:config.ini)"
}
teste_merge_concluido() {
    montar_conflito; executar
    afirmar_igual "2" "$(git -C loja log -1 --format=%p | wc -w | tr -d ' ')" "o último commit deve ser um merge (2 pais)"
    afirmar_igual "" "$(git -C loja status --porcelain)" "nada pendente"
}
teste_trouxe_o_resto_da_feature() {
    montar_conflito; executar
    afirmar_arquivo loja/nf.txt "o que não conflitou na feature também entra"
}
