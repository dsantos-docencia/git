# 🏋️ Exercícios — Módulo 07

Edite os arquivos `.sh` desta pasta e corrija com:

```bash
./ferramentas/corrigir.sh 07        # todos do módulo
./ferramentas/corrigir.sh 07 01     # só o exercício 01
```

Aqui o corretor confere o **formato do histórico**: linearidade, quantidade de commits, mensagens e de onde cada commit veio. Rebase interativo em script: use `GIT_SEQUENCE_EDITOR` (veja o exemplo 02) — ou outra técnica que chegue ao mesmo resultado.

O corretor roda cada script numa **pasta temporária vazia**, com identidade Git fixa (`Aluno Git <aluno@curso.dev>`) e branch inicial `main` — você não precisa configurar nada para os exercícios funcionarem. Travou? As soluções comentadas estão em [solucoes/](solucoes/). Tente pelo menos 15 minutos antes de abrir.

---

### 01 — Feature em cima da main atual · `01-rebase-na-main.sh`
No repositório `loja`, a branch `feature/cupom` (2 commits) saiu de um ponto antigo da `main`, que depois recebeu `fix: corrige total`. Faça **rebase** da feature sobre a `main` atual e, em seguida, integre na `main` **por avanço rápido**. O histórico da `main` deve ficar **linear** (sem commit de merge) e terminar com os dois commits da feature.

### 02 — Limpar a feature antes do PR · `02-juntar-commits.sh`
A branch atual do repositório `app` tem, depois de `feat: base`, quatro commits: `feat: modelo de cupom`, `wip`, `ajuste`, `corrige teste`. Transforme esses quatro em **um único commit** com a mensagem `feat: cupom de desconto`, mantendo o conteúdo final dos arquivos igual.

### 03 — Hotfix na release · `03-cherry-pick-hotfix.sh`
No repositório `loja`, a `main` tem um commit `fix: falha de segurança no login` (entre outros). Leve **somente** esse commit para a branch `release/1.x`, **anotando a origem** na mensagem (a linha “cherry picked from commit …”). A `release/1.x` não pode receber a tela nova (`tela.txt`).

<sub>© 2026 Prof. Daniel Santos · CC BY-NC-SA 4.0</sub>
