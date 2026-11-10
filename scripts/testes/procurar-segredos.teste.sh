# shellcheck shell=bash
# Testes de scripts/auditoria/procurar-segredos.sh
teste_encontra_segredo_apagado() {
    git init -q repo
    commitar cfg.ini "chave=AKIAABCDEFGHIJKLMNOP" "chore: config" repo
    git -C repo rm -q cfg.ini && git -C repo commit -q -m "chore: remove config"
    executar repo
    afirmar_status 1
    afirmar_contem "chave-aws" "$SAIDA" "o segredo continua no HISTÓRICO, mesmo apagado"
}
teste_repo_limpo() {
    git init -q repo; commitar app.py "print(1)" "feat: app" repo
    executar repo
    afirmar_status 0
}
