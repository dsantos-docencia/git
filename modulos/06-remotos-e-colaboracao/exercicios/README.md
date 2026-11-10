# 🏋️ Exercícios — Módulo 06

Edite os arquivos `.sh` desta pasta e corrija com:

```bash
./ferramentas/corrigir.sh 06        # todos do módulo
./ferramentas/corrigir.sh 06 01     # só o exercício 01
```

Tudo acontece com repositórios locais: um `servidor.git` (bare) faz o papel da plataforma. Nada vai para a internet.

O corretor roda cada script numa **pasta temporária vazia**, com identidade Git fixa (`Aluno Git <aluno@curso.dev>`) e branch inicial `main` — você não precisa configurar nada para os exercícios funcionarem. Travou? As soluções comentadas estão em [solucoes/](solucoes/). Tente pelo menos 15 minutos antes de abrir.

---

### 01 — Publicar uma branch com upstream · `01-publicar-branch.sh`
Existe `servidor.git` (bare) e o clone `ana`, já com um commit na `main`. Dentro de `ana`:
1. crie a branch `feature/frete` com um commit `feat: frete` (arquivo livre);
2. publique a branch no `origin` **configurando o upstream** (para que `git status` mostre `origin/feature/frete`).

### 02 — Atualizar a main com segurança · `02-atualizar-sem-merge.sh`
O colega publicou dois commits no `servidor.git`. O seu clone `ana` está **atrás** (sem commits próprios). Atualize a `main` da Ana **somente se for avanço rápido** — seu script não pode criar commit de merge em hipótese alguma.

### 03 — Sincronizar o fork · `03-sincronizar-fork.sh`
Os testes criam: `original.git` (o projeto original), `fork.git` (o seu fork) e `voce` (clone do **fork**, com `origin` → `fork.git`). O original recebeu um commit novo.

No clone `voce`:
1. adicione o remoto `upstream` apontando para `../original.git`;
2. traga a `main` do upstream para a sua `main` (só avanço rápido);
3. publique a `main` atualizada no **seu fork** (`origin`).

<sub>© 2026 Prof. Daniel Santos · CC BY-NC-SA 4.0</sub>
