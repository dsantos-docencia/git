# shellcheck shell=bash
# Testes do exercício 08.03 — Notas da versão
montar() {
    git init -q app
    commitar a 1 "feat: versão inicial" app; git -C app tag v1.0.0
    commitar b 1 "feat(pedidos): calcula frete por CEP" app
    commitar c 1 "fix: corrige total" app
    commitar d 1 "feat: cupom de desconto" app
    commitar e 1 "docs: readme" app; git -C app tag v1.1.0
    commitar f 1 "feat: depois da release" app
}
teste_saida_exata() {
    montar; executar
    afirmar_igual $'calcula frete por CEP\ncupom de desconto' "$SAIDA"
}
