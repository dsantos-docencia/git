#!/usr/bin/env bash
# ============================================================================
#  Curso de Git — laboratorio/criar-time.sh
#  Simula um time de duas pessoas e um "servidor" — sem internet e sem conta
#  em plataforma nenhuma. É o laboratório dos módulos de remotos e conflitos.
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  USO     bash laboratorio/criar-time.sh [pasta-destino]     (padrão: lab-time)
#  CRIA    pasta-destino/
#            servidor.git/   repositório "bare" (sem arquivos de trabalho) = o servidor
#            ana/            clone da Ana  (identidade própria, nível local)
#            bia/            clone da Bia  (identidade própria, nível local)
# ============================================================================
set -euo pipefail

DESTINO="${1:-lab-time}"
if [[ -e "$DESTINO" ]]; then
    printf 'A pasta "%s" já existe. Apague-a (rm -rf %s) ou informe outro nome.\n' "$DESTINO" "$DESTINO" >&2
    exit 1
fi
mkdir -p -- "$DESTINO"
cd -- "$DESTINO"

# Um repositório "bare" é o que roda nos servidores (GitHub, GitLab, Bitbucket):
# só a pasta .git, sem diretório de trabalho. Ninguém edita arquivos nele.
git init -q --bare servidor.git
git -C servidor.git symbolic-ref HEAD refs/heads/main

pessoa() {   # pessoa NOME EMAIL
    local pasta
    pasta="$(tr '[:upper:]' '[:lower:]' <<<"$1")"
    git clone -q servidor.git "$pasta" 2>/dev/null
    git -C "$pasta" config user.name  "$1 (lab)"
    git -C "$pasta" config user.email "$2"
    git -C "$pasta" switch -q -c main 2>/dev/null || git -C "$pasta" switch -q main
}

pessoa Ana ana@lab.local
printf '# Projeto do time\n\nLaboratório de colaboração do Curso de Git.\n' > ana/README.md
git -C ana add README.md
git -C ana commit -q -m "docs: cria README do projeto"
git -C ana push -q -u origin main

pessoa Bia bia@lab.local
git -C bia pull -q origin main

cat <<MSG
Laboratório criado em: $(pwd)

  servidor.git/  → o "servidor" (repositório bare)
  ana/           → clone da Ana
  bia/           → clone da Bia (já com o commit da Ana)

Experimente:
  cd $(pwd)/ana && echo "linha da Ana" >> README.md && git commit -am "docs: linha da Ana" && git push
  cd $(pwd)/bia && git pull && git log --oneline

Para provocar um conflito, edite a MESMA linha do README nos dois clones,
faça commit nos dois e dê push primeiro na Ana, depois na Bia.
Para recomeçar do zero: rm -rf $(pwd)
MSG
