# Projeto 02 · Guardião de push

**Problema:** no time da loja, alguém fez `git push --force` na `main` e apagou dois dias de trabalho. A plataforma vai ganhar regras de proteção (cursos de GitHub/GitLab/Bitbucket), mas você quer uma primeira barreira **na máquina de cada pessoa**.

**Entrega:** `guardiao.sh`, um hook **`pre-push`** que recusa:

1. push direto para `main`/`master` (liberável em emergência com `PERMITIR_PUSH_MAIN=1`);
2. apagar `main`/`master` no servidor;
3. qualquer push que **reescreva** histórico publicado (não fast-forward).

```bash
mkdir -p .githooks && cp projetos/02-guardiao-de-push/guardiao.sh .githooks/pre-push
chmod +x .githooks/pre-push && git config core.hooksPath .githooks
```

**Como o Git conversa com o hook:** argumentos `$1` (nome do remoto) e `$2` (URL); na entrada padrão, uma linha por referência enviada: `<ref local> <sha local> <ref remota> <sha remoto>`. Um sha só de zeros significa “não existe” (criação ou remoção). “Não é fast-forward” = o commit remoto **não é ancestral** do local → `git merge-base --is-ancestor`.

**Conceitos usados:** Módulos 06 (push e avanço rápido), 07 (reescrita), 10 (objetos e ancestralidade) e 11 (hooks).

**Desafios extras:** ler a lista de branches protegidas de `git config guardiao.protegidas`; exigir que a branch siga o padrão `feature/*|fix/*|hotfix/*`; rodar os testes antes do push.

> 🧠 Lembre do Módulo 11: hook local é **ajuda** (`git push --no-verify` o ignora). A garantia de verdade é a proteção de branch no servidor.

<sub>© 2026 Prof. Daniel Santos · CC BY-NC-SA 4.0</sub>
