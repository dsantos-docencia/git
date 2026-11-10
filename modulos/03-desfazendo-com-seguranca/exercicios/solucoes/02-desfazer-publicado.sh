#!/usr/bin/env bash
# Curso de Git · Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC · não comercial)
# Exercício 03.02 — Desfazer um commit já publicado · SOLUÇÃO COMENTADA
set -euo pipefail

# Encontra o hash pelo assunto (--grep busca na mensagem; -F = texto literal)
alvo="$(git -C app log --format=%H -F --grep='feat: cupom com bug')"
# revert cria um commit NOVO com o inverso das mudanças; --no-edit aceita a mensagem padrão
git -C app revert --no-edit "$alvo" >/dev/null
