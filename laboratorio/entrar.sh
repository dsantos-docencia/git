#!/usr/bin/env bash
# ============================================================================
#  Curso de Git — laboratorio/entrar.sh
#  Abre um terminal dentro do container do curso, com o repositório montado.
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ============================================================================
set -euo pipefail

RAIZ="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
IMAGEM="curso-git:lab"

if ! command -v docker >/dev/null; then
    cat >&2 <<'MSG'
Docker não encontrado. Instale a partir de https://docs.docker.com/get-docker/
Sem Docker, você usa o curso direto no Git da sua máquina — o container é só
uma conveniência para ter um ambiente idêntico e descartável.
MSG
    exit 1
fi

# Constrói a imagem na primeira vez (ou depois de: docker rmi curso-git:lab).
if ! docker image inspect "$IMAGEM" >/dev/null 2>&1; then
    echo "Construindo a imagem do laboratório (só na primeira vez)…"
    docker build -t "$IMAGEM" "$RAIZ/laboratorio"
fi

echo "Entrando no laboratório. O repositório está em /curso. Digite 'exit' para sair."
# --rm: descartado ao sair · -v: o repositório do curso montado em /curso
exec docker run --rm -it -v "$RAIZ:/curso" "$IMAGEM" bash
