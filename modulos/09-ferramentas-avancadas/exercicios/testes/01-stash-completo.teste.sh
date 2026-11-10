# shellcheck shell=bash
# Testes do exercício 09.01 — Guardar tudo e limpar
montar() {
    git init -q app
    commitar relatorio.txt v1 "feat: relatório" app
    printf 'v1 + ajuste\n' > app/relatorio.txt
    printf 'login\n' > app/login.txt
}
teste_area_limpa() {
    montar; executar
    afirmar_igual "" "$(git -C app status --porcelain)" "nada pode sobrar fora do stash"
}
teste_stash_com_mensagem() {
    montar; executar
    afirmar_contem "meio do login" "$(git -C app stash list)"
}
teste_inclui_nao_rastreado() {
    montar; executar
    # o stash com -u guarda os não rastreados num 3º pai do commit de stash
    git -C app cat-file -e 'stash@{0}^3:login.txt' 2>/dev/null || _falhar "login.txt (não rastreado) não está no stash — faltou o -u?"
}
