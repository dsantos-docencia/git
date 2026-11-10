#!/usr/bin/env bash
# Curso de Git · Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC · não comercial)
# Exercício 01.03 — Ignorando o que não deve ser versionado · SOLUÇÃO COMENTADA
set -euo pipefail

git init -q -b main projeto
cd projeto
cat > .gitignore <<'IGN'
*.log
build/
.env
IGN
printf 'print("olá")\n' > app.py
git add .gitignore app.py
git commit -q -m "chore: estrutura inicial com .gitignore"
mkdir -p build
touch app.log build/saida.bin .env
