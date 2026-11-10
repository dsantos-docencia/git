#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · Módulo 11 · Assinatura SSH
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  OBJETIVO  gerar uma chave, assinar e verificar um commit (Git 2.34+)
#  EXECUTE   bash modulos/11-seguranca-hooks-e-automacao/exemplos/02-assinatura-ssh.sh
# ============================================================================
set -euo pipefail

# --- Laboratório descartável --------------------------------------------------
# Pasta temporária apagada ao final; configuração isolada (não lê nem altera o
# seu ~/.gitconfig); identidade fixa para os commits de demonstração.
LAB="$(mktemp -d)"; trap 'rm -rf -- "$LAB"' EXIT; cd "$LAB"
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL="$LAB/.gitconfig-lab" GIT_PAGER=cat
export GIT_AUTHOR_NAME='Ana Dev' GIT_AUTHOR_EMAIL='ana@exemplo.dev'
export GIT_COMMITTER_NAME='Ana Dev' GIT_COMMITTER_EMAIL='ana@exemplo.dev'
git config --global init.defaultBranch main
git config --global advice.detachedHead false
passo() { printf '\n== %s ==\n' "$*"; }

if ! command -v ssh-keygen >/dev/null; then
    echo "ssh-keygen não encontrado (instale o OpenSSH). Este exemplo mostra o fluxo e termina."
    exit 0
fi

passo "1. Uma chave só para o laboratório (sem senha, apenas para o exemplo)"
ssh-keygen -q -t ed25519 -N '' -C "ana@exemplo.dev" -f "$LAB/chave"
cat "$LAB/chave.pub"

passo "2. Configurando o Git para assinar com SSH"
git config --global gpg.format ssh
git config --global user.signingkey "$LAB/chave.pub"
# Para VERIFICAR, o Git precisa saber quais chaves são confiáveis para quais e-mails
printf 'ana@exemplo.dev %s\n' "$(cat "$LAB/chave.pub")" > "$LAB/allowed_signers"
git config --global gpg.ssh.allowedSignersFile "$LAB/allowed_signers"

passo "3. Commit assinado (-S)"
git init -q app && cd app
printf 'oi\n' > a.txt && git add . && git commit -q -S -m "feat: commit assinado"
git log --show-signature -1 2>&1 | sed -n '1,4p'

passo "4. Status da assinatura em formato de script (%G?: G = válida, N = sem assinatura)"
printf 'oi2\n' > b.txt && git add . && git commit -q -m "feat: sem assinatura"
git log --format='%G? %s'
