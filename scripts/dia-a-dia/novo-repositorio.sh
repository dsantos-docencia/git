#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · scripts/dia-a-dia/novo-repositorio.sh
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  O QUE FAZ  Cria um repositório já no padrão: branch main, README, .gitignore
#             por tipo de projeto, .gitattributes e primeiro commit.
#  USO        novo-repositorio.sh <pasta> [python|node|dotnet|geral]
# ============================================================================
set -euo pipefail

pasta="${1:?uso: novo-repositorio.sh <pasta> [python|node|dotnet|geral]}"
tipo="${2:-geral}"
[[ -e "$pasta" ]] && { echo "'$pasta' já existe" >&2; exit 1; }

git init -q -b main "$pasta"
cd "$pasta"

{   # comum a todos
    echo "# sistema operacional e editores"
    printf '%s\n' .DS_Store Thumbs.db .idea/ .vscode/ '*.swp'
    echo "# segredos — nunca versionar"
    printf '%s\n' .env '.env.*' '!.env.exemplo' '*.pem' '*.key'
    case "$tipo" in
        python) printf '%s\n' '# python' __pycache__/ '*.py[cod]' .venv/ dist/ build/ .pytest_cache/ ;;
        node)   printf '%s\n' '# node' node_modules/ dist/ coverage/ npm-debug.log* ;;
        dotnet) printf '%s\n' '# .NET' bin/ obj/ '*.user' .vs/ ;;
        geral)  printf '%s\n' '# logs e temporários' '*.log' tmp/ ;;
        *) echo "tipo desconhecido: $tipo" >&2; exit 2 ;;
    esac
} > .gitignore

cat > .gitattributes <<'ATTR'
# Normaliza fim de linha no repositório (LF), independentemente do sistema de quem commita
* text=auto eol=lf
# Scripts do Windows precisam de CRLF
*.bat text eol=crlf
*.cmd text eol=crlf
*.ps1 text eol=crlf
# Binários: sem diff textual nem conversão
*.png binary
*.jpg binary
*.pdf binary
*.zip binary
ATTR

printf '# %s\n\nDescreva aqui o que o projeto faz, como rodar e como contribuir.\n' "$(basename "$pasta")" > README.md
printf 'EXEMPLO=valor\n' > .env.exemplo
git add .
git commit -q -m "chore: estrutura inicial do repositório"
echo "✔ Repositório '$pasta' criado ($tipo):"
git log --oneline
git ls-files
