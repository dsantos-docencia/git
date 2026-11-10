# shellcheck shell=bash
# Testes do exercício 10.02 — Um commit sem git add nem git commit
teste_mensagem() {
    executar
    afirmar_igual "feat: commit feito à mão" "$(git -C manual log -1 --format=%s main 2>/dev/null)"
}
teste_conteudo() {
    executar
    afirmar_igual "olá" "$(git -C manual show main:ola.txt 2>/dev/null)"
    afirmar_igual "ola.txt" "$(git -C manual ls-tree --name-only main)" "só um arquivo no commit"
}
teste_sem_porcelana() {
    executar
    alvo="$(sed 's/#.*//' "$ALVO")"
    [[ "$alvo" =~ git[[:space:]]+(-C[[:space:]]+[^[:space:]]+[[:space:]]+)?(add|commit)([[:space:]]|$) ]] && _falhar "não use git add nem git commit neste exercício"
    return 0
}
