# shellcheck shell=bash
# Testes do exercício 01.03 — Ignorando o que não deve ser versionado
teste_status_vazio() {
    executar
    afirmar_igual "" "$(git -C projeto status --porcelain)" "arquivos ignorados não devem aparecer no status"
}
teste_commit_contem_so_dois() {
    executar
    afirmar_igual $'.gitignore\napp.py' "$(git -C projeto ls-tree --name-only HEAD)"
}
teste_ignora_log_em_subpasta() {
    executar
    # a regra deve valer para .log em QUALQUER pasta, não só na raiz
    git -C projeto check-ignore -q docs/qualquer.log || _falhar "*.log deveria ignorar .log em subpastas"
}
teste_ignora_env_e_build() {
    executar
    git -C projeto check-ignore -q .env || _falhar ".env não está ignorado"
    git -C projeto check-ignore -q build/saida.bin || _falhar "build/ não está ignorado"
}
