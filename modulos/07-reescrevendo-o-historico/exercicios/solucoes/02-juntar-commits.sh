#!/usr/bin/env bash
# Curso de Git · Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC · não comercial)
# Exercício 07.02 — Limpar a feature antes do PR · SOLUÇÃO COMENTADA
set -euo pipefail

cd app
# Opção 1 (mais simples): volta a branch 4 commits mantendo tudo preparado, e commita de novo
git reset -q --soft HEAD~4
git commit -q -m "feat: cupom de desconto"
# Opção 2 (rebase interativo sem editor) faria o mesmo:
#   GIT_SEQUENCE_EDITOR="sed -i.bak '2,\$ s/^pick/fixup/'" git rebase -i HEAD~4
#   git commit --amend -m "feat: cupom de desconto"
