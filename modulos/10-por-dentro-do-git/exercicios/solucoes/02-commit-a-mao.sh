#!/usr/bin/env bash
# Curso de Git · Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC · não comercial)
# Exercício 10.02 — Um commit sem git add nem git commit · SOLUÇÃO COMENTADA
set -euo pipefail

git init -q -b main manual && cd manual
blob="$(printf 'olá\n' | git hash-object -w --stdin)"            # grava o conteúdo
git update-index --add --cacheinfo "100644,$blob,ola.txt"          # nome + permissão no índice
tree="$(git write-tree)"                                            # pasta raiz
commit="$(git commit-tree "$tree" -m "feat: commit feito à mão")"   # o commit (sem pai)
git update-ref refs/heads/main "$commit"                            # a branch passa a apontar para ele
