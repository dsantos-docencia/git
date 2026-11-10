# shellcheck shell=bash
# Testes do exercício 11.02 — Um hook do time
montar() { git init -q app; commitar README.md '# App' "docs: readme" app; }
teste_hook_versionado() {
    montar; executar
    afirmar_contem ".githooks/pre-commit" "$(git -C app ls-files)"
    afirmar_igual ".githooks" "$(git -C app config --get core.hooksPath)"
}
teste_bloqueia_senha() {
    montar; executar
    printf 'SENHA=123\n' > app/config.ini
    git -C app add config.ini
    if git -C app commit -q -m "chore: config" 2>/dev/null; then _falhar "o commit com SENHA= deveria ser recusado"; fi
    return 0
}
teste_permite_normal() {
    montar; executar
    printf 'print(1)\n' > app/app.py
    git -C app add app.py
    git -C app commit -q -m "feat: app" 2>/dev/null || _falhar "um commit normal não pode ser bloqueado"
}
teste_hook_foi_commitado_de_fato() {
    montar; executar
    afirmar_igual "chore: adiciona hooks do time" "$(git -C app log -1 --format=%s)" "o commit da pasta .githooks precisa ter acontecido"
}
