# shellcheck shell=bash
# Testes do exercício 02.03 — O que mudou desde a v1.0?
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

teste_lista_exata() {
    montar_historico
    executar
    afirmar_igual $'app.py\nconfig.ini\ndocs/uso.md' "$SAIDA"
}
teste_usa_a_tag() {
    montar_historico
    git -C historico tag -d v1.0 >/dev/null
    git -C historico tag v1.0 HEAD~1
    executar
    afirmar_igual "app.py" "$SAIDA" "com a tag movida, só app.py mudou depois dela"
}
