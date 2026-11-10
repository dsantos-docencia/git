# 🏋️ Exercícios — Módulo 11

Edite os arquivos `.sh` desta pasta e corrija com:

```bash
./ferramentas/corrigir.sh 11        # todos do módulo
./ferramentas/corrigir.sh 11 01     # só o exercício 01
```

Segurança na prática: o corretor testa as regras que você criou tentando burlá-las.

O corretor roda cada script numa **pasta temporária vazia**, com identidade Git fixa (`Aluno Git <aluno@curso.dev>`) e branch inicial `main` — você não precisa configurar nada para os exercícios funcionarem. Travou? As soluções comentadas estão em [solucoes/](solucoes/). Tente pelo menos 15 minutos antes de abrir.

---

### 01 — Regras que viajam com o repositório · `01-gitattributes.sh`
Crie o repositório `app` com um commit contendo um `.gitattributes` que garanta:
- todo arquivo de texto com fim de linha **LF** (`* text=auto eol=lf`);
- arquivos `.ps1` e `.bat` com **CRLF**;
- arquivos `.png` e `.pdf` tratados como **binários**.

### 02 — Um hook do time · `02-hook-anti-segredo.sh`
No repositório `app` (já existente), crie um hook **pre-commit** numa pasta **versionada** `.githooks` e configure o repositório para usá-la (`core.hooksPath`). O hook deve **recusar** o commit quando algum arquivo **preparado** contiver o texto `SENHA=`, e permitir os demais. Por fim, commite a pasta `.githooks` com a mensagem `chore: adiciona hooks do time`.

> 🪤 Pegadinha real: o hook também é commitado. Se o texto `SENHA=` aparecer **literalmente** dentro dele, ele bloqueia o próprio commit.

### 03 — Tirar o segredo do histórico · `03-limpar-historico.sh`
No repositório `loja`, o arquivo `.env` (com uma chave) foi commitado no 2º commit e removido no 3º. A chave **já foi trocada**. Agora reescreva o histórico de **todas as branches** para que **nenhum commit** contenha `.env`, preservando os demais arquivos. Ao final, apague o backup que a ferramenta eventualmente deixar (`refs/original/*`).

Ferramenta recomendada: `git filter-repo` (se instalada). Sem ela, `git filter-branch --index-filter` resolve (veja o exemplo 03).

<sub>© 2026 Prof. Daniel Santos · CC BY-NC-SA 4.0</sub>
