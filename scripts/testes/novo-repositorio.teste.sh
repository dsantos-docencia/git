# shellcheck shell=bash
# Testes de scripts/dia-a-dia/novo-repositorio.sh
teste_cria_estrutura_python() {
    executar meu-app python
    afirmar_status 0
    afirmar_igual "1" "$(git -C meu-app rev-list --count HEAD)"
    git -C meu-app check-ignore -q .venv/x || _falhar ".venv/ deveria ser ignorado no tipo python"
    git -C meu-app check-ignore -q .env || _falhar ".env deveria ser ignorado"
    afirmar_contem ".env.exemplo" "$(git -C meu-app ls-files)" "o modelo .env.exemplo deve ser versionado"
}
teste_recusa_pasta_existente() {
    mkdir existe; executar existe
    afirmar_status_diferente_de_zero
}
