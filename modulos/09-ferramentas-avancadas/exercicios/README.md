# 🏋️ Exercícios — Módulo 09

Edite os arquivos `.sh` desta pasta e corrija com:

```bash
./ferramentas/corrigir.sh 09        # todos do módulo
./ferramentas/corrigir.sh 09 01     # só o exercício 01
```

Stash, bisect e worktree em situações de emergência. O corretor confere o estado do repositório depois do seu script.

O corretor roda cada script numa **pasta temporária vazia**, com identidade Git fixa (`Aluno Git <aluno@curso.dev>`) e branch inicial `main` — você não precisa configurar nada para os exercícios funcionarem. Travou? As soluções comentadas estão em [solucoes/](solucoes/). Tente pelo menos 15 minutos antes de abrir.

---

### 01 — Guardar tudo e limpar · `01-stash-completo.sh`
No repositório `app` há trabalho pela metade: `relatorio.txt` **modificado** e `login.txt` **novo** (não rastreado). Guarde **tudo** (inclusive o arquivo novo) num stash com a mensagem `meio do login`, deixando o diretório de trabalho limpo.

### 02 — Caçar o commit culpado · `02-cacar-o-bug.sh`
O repositório `loja` tem 30 commits. Na tag `v1.0` o arquivo `relatorio.txt` continha `total = a + b`; hoje contém `total = a - b`. Imprima **somente o assunto** do **primeiro** commit em que o relatório ficou errado.

Use `git bisect` (de preferência com `bisect run`) e **termine com `git bisect reset`** — o repositório deve voltar para a `main`.

### 03 — Hotfix numa segunda pasta · `03-worktree-hotfix.sh`
No repositório `app` você está na branch `feature/login` com trabalho não commitado (não mexa nele). Crie uma **worktree** na pasta `app-hotfix` (ao lado de `app`), numa branch **nova** chamada `hotfix/relatorio` criada a partir da `main`. Nessa worktree, faça um commit `fix: relatório de vendas` alterando `relatorio.txt` (conteúdo livre).

<sub>© 2026 Prof. Daniel Santos · CC BY-NC-SA 4.0</sub>
