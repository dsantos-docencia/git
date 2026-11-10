#!/usr/bin/env bash
# Curso de Git · Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC · não comercial)
# Exercício 09.02 — Caçar o commit culpado · SOLUÇÃO COMENTADA
set -euo pipefail

cd loja
# O teste: status 0 = bom (soma), 1 = ruim. Escrito num arquivo FORA do repositório.
teste="$(mktemp)"
printf '#!/usr/bin/env bash\ngrep -q "a + b" relatorio.txt\n' > "$teste"
chmod +x "$teste"
git bisect start HEAD v1.0 >/dev/null
git bisect run "$teste" >/dev/null 2>&1
git log -1 --format=%s refs/bisect/bad      # o bisect marca o primeiro commit ruim nesta ref
git bisect reset >/dev/null 2>&1
rm -f "$teste"
