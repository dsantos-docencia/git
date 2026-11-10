# shellcheck shell=bash
# Testes do exercício 11.01 — Regras que viajam com o repositório
atributo() { git -C app check-attr "$1" -- "$2" | awk -F': ' '{print $3}'; }
teste_commitado() {
    executar
    afirmar_contem ".gitattributes" "$(git -C app ls-files)" "o .gitattributes precisa estar commitado"
}
teste_lf_padrao() { executar; afirmar_igual "lf" "$(atributo eol src/app.py)"; }
teste_crlf_windows() {
    executar
    afirmar_igual "crlf" "$(atributo eol deploy.ps1)"
    afirmar_igual "crlf" "$(atributo eol build.bat)"
}
teste_binarios() {
    executar
    afirmar_igual "unset" "$(atributo diff logo.png)" "binary desliga o diff textual"
    afirmar_igual "unset" "$(atributo text manual.pdf)"
}
