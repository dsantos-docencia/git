# shellcheck shell=bash
# Testes do exercício 06.02 — Atualizar a main com segurança
montar() {
    git init -q --bare servidor.git
    git clone -q servidor.git ana 2>/dev/null
    commitar README.md '# Loja' "docs: readme" ana
    git -C ana push -q -u origin main
    git clone -q servidor.git colega
    commitar a.txt a "feat: a" colega; commitar b.txt b "feat: b" colega
    git -C colega push -q
}
teste_main_atualizada() {
    montar; executar
    afirmar_igual "$(git -C servidor.git rev-parse main)" "$(git -C ana rev-parse main)"
}
teste_sem_merge() {
    montar; executar
    afirmar_igual "0" "$(git -C ana rev-list --merges --count main)"
}
