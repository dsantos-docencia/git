# 🏋️ Exercícios — Módulo 04

Edite os arquivos `.sh` desta pasta e corrija com:

```bash
./ferramentas/corrigir.sh 04        # todos do módulo
./ferramentas/corrigir.sh 04 01     # só o exercício 01
```

Os testes montam o repositório `loja` (ou pedem que você o crie) e verificam ponteiros, pais dos commits e o grafo.

O corretor roda cada script numa **pasta temporária vazia**, com identidade Git fixa (`Aluno Git <aluno@curso.dev>`) e branch inicial `main` — você não precisa configurar nada para os exercícios funcionarem. Travou? As soluções comentadas estão em [solucoes/](solucoes/). Tente pelo menos 15 minutos antes de abrir.

---

### 01 — Feature com avanço rápido · `01-feature-e-ff.sh`
Crie o repositório `loja` com um commit `feat: base` na `main`. Depois:
1. crie a branch `feature/frete` e nela faça um commit `feat: frete` (arquivo `frete.txt`, conteúdo livre);
2. volte para a `main` e mescle a feature **por avanço rápido** (sem commit de merge);
3. apague a branch `feature/frete`.

Ao final: `main` com 2 commits, sem commit de merge, e a branch apagada.

### 02 — Merge de três vias registrado · `02-merge-tres-vias.sh`
Os testes criam o repositório `loja`: na `main` há `feat: base` e depois `fix: hotfix`; a branch `feature/cupom` saiu de `feat: base` e tem o commit `feat: cupom`. Mescle `feature/cupom` na `main` criando um **commit de merge** com a mensagem exata `Merge: cupom de desconto`.

### 03 — Integrar com squash · `03-squash.sh`
Os testes criam o repositório `loja` com a branch `feature/login` contendo **três** commits `wip: …`. Integre o trabalho na `main` como **um único commit** com a mensagem `feat: login completo` (os `wip` não podem aparecer no histórico da `main`). Depois apague a branch `feature/login`.

<sub>© 2026 Prof. Daniel Santos · CC BY-NC-SA 4.0</sub>
