# shellcheck shell=bash
# Testes de scripts/dia-a-dia/limpar-branches-mescladas.sh
montar() {
    git init -q repo && { cd repo || exit 1; }
    commitar a.txt 1 "feat: base"
    git branch mesclada
    git switch -q -c pendente && commitar b.txt 2 "feat: pendente" && git switch -q main
}
teste_simula_por_padrao() {
    montar; executar
    afirmar_contem "mesclada" "$SAIDA"
    afirmar_contem "simulação" "$SAIDA"
    git show-ref -q --verify refs/heads/mesclada || _falhar "não deveria apagar sem --aplicar"
}
teste_aplica_so_mescladas() {
    montar; executar --aplicar
    git show-ref -q --verify refs/heads/mesclada && _falhar "a branch mesclada deveria ter sido apagada"
    git show-ref -q --verify refs/heads/pendente || _falhar "a branch NÃO mesclada não pode ser apagada"
    git show-ref -q --verify refs/heads/main || _falhar "a principal nunca é apagada"
}
