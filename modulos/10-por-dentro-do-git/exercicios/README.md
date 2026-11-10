# 🏋️ Exercícios — Módulo 10

Edite os arquivos `.sh` desta pasta e corrija com:

```bash
./ferramentas/corrigir.sh 10        # todos do módulo
./ferramentas/corrigir.sh 10 01     # só o exercício 01
```

Só comandos de **encanamento**: o corretor confere objetos, hashes e referências.

O corretor roda cada script numa **pasta temporária vazia**, com identidade Git fixa (`Aluno Git <aluno@curso.dev>`) e branch inicial `main` — você não precisa configurar nada para os exercícios funcionarem. Travou? As soluções comentadas estão em [solucoes/](solucoes/). Tente pelo menos 15 minutos antes de abrir.

---

### 01 — Que objeto é este? · `01-tipos-de-objeto.sh`
No repositório `obj`, imprima o **tipo** de cada um destes objetos, um por linha e nesta ordem: `HEAD`, a tree raiz de `HEAD`, o arquivo `README.md` em `HEAD`, a tag `v1.0`. Para o repositório dos testes:
```
commit
tree
blob
tag
```

### 02 — Um commit sem git add nem git commit · `02-commit-a-mao.sh`
Crie o repositório `manual` e, **sem usar `git add` nem `git commit`**, faça a branch `main` apontar para um commit com:
- um único arquivo `ola.txt` com o conteúdo `olá` (seguido de quebra de linha);
- a mensagem `feat: commit feito à mão`.

Comandos de que você vai precisar: `hash-object -w`, `update-index --add --cacheinfo`, `write-tree`, `commit-tree`, `update-ref`.

### 03 — O maior arquivo de todos os tempos · `03-maior-do-historico.sh`
O repositório `app` está pesado. Imprima o **caminho** do **maior arquivo que já foi commitado** em qualquer momento do histórico de qualquer branch — inclusive se hoje ele já foi apagado.

Dica: `git rev-list --objects --all` + `git cat-file --batch-check`.

<sub>© 2026 Prof. Daniel Santos · CC BY-NC-SA 4.0</sub>
