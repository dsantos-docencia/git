# shellcheck shell=bash
# Testes do projeto 02 — guardiao.sh (instalado como hook pre-push num clone)
montar() {
    git init -q --bare servidor.git
    git clone -q servidor.git dev 2>/dev/null
    commitar a.txt 1 "feat: a" dev
    git -C dev push -q -u origin main            # antes do hook: publica a main inicial
    mkdir -p dev/.githooks && cp "$ALVO" dev/.githooks/pre-push && chmod +x dev/.githooks/pre-push
    git -C dev config core.hooksPath .githooks
}
teste_bloqueia_push_na_main() {
    montar; commitar b.txt 1 "feat: b" dev
    git -C dev push -q 2>/dev/null && _falhar "push direto na main deveria ser bloqueado"
    return 0
}
teste_permite_branch_de_feature() {
    montar; git -C dev switch -q -c feature/x; commitar c.txt 1 "feat: c" dev
    git -C dev push -q -u origin feature/x 2>/dev/null || _falhar "push de feature nova deve passar"
}
teste_bloqueia_force_push() {
    montar; git -C dev switch -q -c feature/y; commitar c.txt 1 "feat: c" dev
    git -C dev push -q -u origin feature/y 2>/dev/null
    git -C dev commit -q --amend -m "feat: c reescrito"
    git -C dev push -q --force origin feature/y 2>/dev/null && _falhar "reescrever histórico publicado deveria ser bloqueado"
    return 0
}
teste_emergencia_com_variavel() {
    montar; commitar b.txt 1 "fix: urgente" dev
    PERMITIR_PUSH_MAIN=1 git -C dev push -q 2>/dev/null || _falhar "com PERMITIR_PUSH_MAIN=1 o push na main passa"
}
teste_bloqueia_apagar_main() {
    montar
    git -C dev push -q origin --delete main 2>/dev/null && _falhar "apagar a main no servidor deve ser bloqueado"
    return 0
}
