#!/usr/bin/env bash
# Curso de Git · Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC · não comercial)
# Exercício 07.01 — Feature em cima da main atual · SOLUÇÃO COMENTADA
set -euo pipefail

cd loja
git switch -q feature/cupom
git rebase -q main                 # reaplica os commits da feature em cima da main
git switch -q main
git merge -q --ff-only feature/cupom
