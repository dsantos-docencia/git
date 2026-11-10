# shellcheck shell=bash
# Testes do exercício 06.01 — Publicar uma branch com upstream
montar() {
    git init -q --bare servidor.git
    git clone -q servidor.git ana 2>/dev/null
    commitar README.md '# Loja' "docs: readme" ana
    git -C ana push -q -u origin main
}
teste_branch_no_servidor() {
    montar; executar
    afirmar_igual "feat: frete" "$(git -C servidor.git log -1 --format=%s feature/frete 2>/dev/null)"
}
teste_upstream_configurado() {
    montar; executar
    afirmar_igual "origin/feature/frete" "$(git -C ana rev-parse --abbrev-ref 'feature/frete@{upstream}' 2>/dev/null)"
}
