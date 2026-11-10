# 🏋️ Exercícios — Módulo 05

Edite os arquivos `.sh` desta pasta e corrija com:

```bash
./ferramentas/corrigir.sh 05        # todos do módulo
./ferramentas/corrigir.sh 05 01     # só o exercício 01
```

Os testes montam o repositório `loja` com um conflito entre a `main` e a `feature/imposto`. Seu script resolve e **conclui** a operação — o corretor confere o conteúdo final, o commit de merge e se sobrou algum marcador.

O corretor roda cada script numa **pasta temporária vazia**, com identidade Git fixa (`Aluno Git <aluno@curso.dev>`) e branch inicial `main` — você não precisa configurar nada para os exercícios funcionarem. Travou? As soluções comentadas estão em [solucoes/](solucoes/). Tente pelo menos 15 minutos antes de abrir.

---

### 01 — Resolver à mão · `01-resolver-a-mao.sh`
No repositório `loja`, faça `git merge feature/imposto` (vai dar conflito no `config.ini`). A decisão de negócio é: **taxa da feature** (`0.18`) e **frete da main** (`12`). O `config.ini` final deve ser exatamente:
```
MOEDA=BRL
TAXA=0.18
FRETE=12
```
Conclua o merge (commit com a mensagem padrão, sem abrir editor).

### 02 — Escolher um lado do arquivo · `02-escolher-lado.sh`
No repositório `loja`, mescle `feature/imposto`. Desta vez a decisão é ficar com o `config.ini` **inteiro da feature** (a versão que está chegando). Use a opção do Git que escolhe um lado — sem reescrever o arquivo à mão — e conclua o merge sem abrir editor.

### 03 — Desistir com segurança · `03-abortar.sh`
No repositório `loja`, comece o merge de `feature/imposto` e, ao ver o conflito, **desista**: o repositório deve voltar exatamente ao estado de antes do merge (mesmo commit, `config.ini` da main, nada pendente).

<sub>© 2026 Prof. Daniel Santos · CC BY-NC-SA 4.0</sub>
