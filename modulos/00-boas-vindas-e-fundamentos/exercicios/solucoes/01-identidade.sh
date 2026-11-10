#!/usr/bin/env bash
# Curso de Git · Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC · não comercial)
# Exercício 00.01 — Identidade local · SOLUÇÃO COMENTADA
set -euo pipefail

# -b main: nome da branch inicial (Git 2.28+), independente da configuração da máquina
git init -q -b main projeto
# -C <pasta>: executa o comando "como se" estivesse dentro da pasta, sem precisar de cd
git -C projeto config --local user.name  "Aluno Git"
git -C projeto config --local user.email "aluno@curso.dev"
