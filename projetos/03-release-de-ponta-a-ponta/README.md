# Projeto 03 · Release de ponta a ponta

**Problema:** cada release da loja é feita à mão, por quem lembra dos passos — e uma vez a tag saiu num commit que não estava no servidor. Você vai transformar a receita do Módulo 08 num comando único e seguro.

**Entrega:** `release.sh [--branch main] [--publicar]` que:

1. **confere** que você está na branch certa, sem mudanças pendentes e **idêntico** ao `origin` (nem atrás, nem à frente);
2. **calcula** a próxima versão pelos Conventional Commits ([`scripts/release/proxima-versao.sh`](../../scripts/release/proxima-versao.sh));
3. **acrescenta** as notas no topo do `CHANGELOG.md` ([`gerar-changelog.sh`](../../scripts/release/gerar-changelog.sh));
4. **commita** `chore(release): vX.Y.Z` e cria a **tag anotada**;
5. com `--publicar`, envia branch e tag (`--follow-tags`).

```console
$ bash projetos/03-release-de-ponta-a-ponta/release.sh --publicar
✔ v1.4.0: commit e tag criados.
✔ publicado em origin/main com a tag v1.4.0.
```

**Conceitos usados:** `rev-list --left-right --count` para ahead/behind (Módulo 06), Conventional Commits, SemVer e tags (Módulo 08), códigos de saída para automação.

**Desafios extras:** modo `--simular` que mostra tudo sem gravar; criar a Release na plataforma pela CLI (`gh release create`, `glab release create`); assinar a tag (`-s`).

<sub>© 2026 Prof. Daniel Santos · CC BY-NC-SA 4.0</sub>
