# shellcheck shell=bash
# Testes de scripts/hooks/pre-commit.sh
teste_bloqueia_env() {
    git init -q repo && { cd repo || exit 1; }; echo "SENHA=1" > .env; git add .env; executar
    afirmar_status_diferente_de_zero; afirmar_contem ".env" "$ERRO"
}
teste_bloqueia_chave_no_conteudo() {
    git init -q repo && { cd repo || exit 1; }; echo "aws = AKIAABCDEFGHIJKLMNOP" > cfg.txt; git add cfg.txt; executar
    afirmar_status_diferente_de_zero
}
teste_bloqueia_arquivo_grande() {
    git init -q repo && { cd repo || exit 1; }; head -c 3072 /dev/zero > grande.bin; git add grande.bin
    LIMITE_KB=2 executar
    afirmar_status_diferente_de_zero; afirmar_contem "Git LFS" "$ERRO"
}
teste_libera_commit_normal() {
    git init -q repo && { cd repo || exit 1; }; echo "print(1)" > app.py; git add app.py; executar
    afirmar_status 0
}
