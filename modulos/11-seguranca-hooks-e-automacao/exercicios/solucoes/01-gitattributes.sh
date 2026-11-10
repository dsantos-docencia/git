#!/usr/bin/env bash
# Curso de Git · Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC · não comercial)
# Exercício 11.01 — Regras que viajam com o repositório · SOLUÇÃO COMENTADA
set -euo pipefail

git init -q -b main app && cd app
cat > .gitattributes <<'ATTR'
* text=auto eol=lf
*.ps1 text eol=crlf
*.bat text eol=crlf
*.png binary
*.pdf binary
ATTR
git add .gitattributes
git commit -q -m "chore: normaliza fim de linha e binários"
