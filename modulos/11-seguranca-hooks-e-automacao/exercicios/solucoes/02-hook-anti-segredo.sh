#!/usr/bin/env bash
# Curso de Git · Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC · não comercial)
# Exercício 11.02 — Um hook do time · SOLUÇÃO COMENTADA
set -euo pipefail

cd app
mkdir -p .githooks
cat > .githooks/pre-commit <<'HOOK'
#!/usr/bin/env bash
# Procura o texto proibido apenas nas linhas ADICIONADAS do que está preparado.
# O padrão é montado em duas partes de propósito: se o hook contivesse o texto
# literal, ele bloquearia o commit DELE MESMO (a pasta .githooks também é commitada).
proibido='SENHA''='
if git diff --cached -U0 | grep -E '^\+' | grep -qF "$proibido"; then
    echo "✘ commit bloqueado: há uma senha no conteúdo preparado" >&2
    exit 1
fi
HOOK
chmod +x .githooks/pre-commit
git config core.hooksPath .githooks
git add .githooks
git commit -q -m "chore: adiciona hooks do time"
