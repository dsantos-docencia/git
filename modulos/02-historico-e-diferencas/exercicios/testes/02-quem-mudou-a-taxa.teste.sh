# shellcheck shell=bash
# Testes do exercício 02.02 — Quem mudou a taxa?
# Monta o repositório "historico" que o seu script vai investigar
montar_historico() {
    git init -q historico
    commitar config.ini $'MOEDA=BRL\nTAXA=0.12' "feat: configuração inicial" historico
    commitar app.py 'def total(v): return v' "feat: função total" historico
    git -C historico tag v1.0
    commitar config.ini $'MOEDA=BRL\nTAXA=0.15' "chore: ajusta parâmetros" historico
    commitar docs/uso.md '# Uso' "docs: guia de uso" historico
    commitar app.py 'def total(v): return v * 1.15' "feat: aplica imposto" historico
}

teste_assunto_do_commit() {
    montar_historico
    executar
    afirmar_igual "chore: ajusta parâmetros" "$SAIDA"
}
teste_nao_e_o_ultimo_commit() {
    montar_historico
    executar
    afirmar_nao_contem "aplica imposto" "$SAIDA" "a resposta não é simplesmente o último commit"
}
