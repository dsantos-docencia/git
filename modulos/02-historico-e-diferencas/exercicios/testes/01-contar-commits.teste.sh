# shellcheck shell=bash
# Testes do exercício 02.01 — Quantos commits?
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

teste_conta_cinco() {
    montar_historico
    executar
    afirmar_igual "5" "$SAIDA"
}
teste_acompanha_novos_commits() {
    montar_historico
    commitar extra.txt 'x' "chore: extra" historico
    executar
    afirmar_igual "6" "$SAIDA" "o número deve vir do repositório, não ser fixo no script"
}
