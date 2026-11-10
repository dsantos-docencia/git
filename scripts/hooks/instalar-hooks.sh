#!/usr/bin/env bash
# ============================================================================
#  Curso de Git · scripts/hooks/instalar-hooks.sh
#  Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
# ----------------------------------------------------------------------------
#  O QUE FAZ  Instala os hooks do curso no repositório atual, numa pasta
#             VERSIONADA (.githooks) + core.hooksPath — assim o time inteiro
#             usa os mesmos hooks (diferente de .git/hooks, que não é versionado).
#  USO        bash /caminho/do/curso/scripts/hooks/instalar-hooks.sh
# ============================================================================
set -euo pipefail

origem="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
raiz="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "rode dentro de um repositório Git" >&2; exit 1; }
mkdir -p "$raiz/.githooks"
for hook in commit-msg pre-commit; do
    install -m 0755 "$origem/$hook.sh" "$raiz/.githooks/$hook"
done
git -C "$raiz" config core.hooksPath .githooks
echo "✔ Hooks instalados em $raiz/.githooks (core.hooksPath configurado)."
echo "  Versione a pasta: git add .githooks && git commit -m 'chore: adiciona hooks do time'"
echo "  Cada pessoa do time roda uma vez: git config core.hooksPath .githooks"
