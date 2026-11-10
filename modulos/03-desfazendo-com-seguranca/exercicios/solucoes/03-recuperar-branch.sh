#!/usr/bin/env bash
# Curso de Git · Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC · não comercial)
# Exercício 03.03 — Branch apagada por engano · SOLUÇÃO COMENTADA
set -euo pipefail

# log -g percorre o reflog do HEAD; pegamos o hash da primeira entrada com o assunto
sha="$(git -C app log -g --format='%H %s' | awk '/exp: ideia ousada/ {print $1; exit}')"
git -C app branch experimento "$sha"
