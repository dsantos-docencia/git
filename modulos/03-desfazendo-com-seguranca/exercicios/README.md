# 🏋️ Exercícios — Módulo 03

Edite os arquivos `.sh` desta pasta e corrija com:

```bash
./ferramentas/corrigir.sh 03        # todos do módulo
./ferramentas/corrigir.sh 03 01     # só o exercício 01
```

Os testes montam o repositório `app` com um “problema”; seu script conserta. Leia o enunciado e escolha a ferramenta certa — o corretor verifica se o histórico ficou do jeito esperado.

O corretor roda cada script numa **pasta temporária vazia**, com identidade Git fixa (`Aluno Git <aluno@curso.dev>`) e branch inicial `main` — você não precisa configurar nada para os exercícios funcionarem. Travou? As soluções comentadas estão em [solucoes/](solucoes/). Tente pelo menos 15 minutos antes de abrir.

---

### 01 — Mensagem ruim no último commit · `01-corrigir-mensagem.sh`
O último commit do repositório `app` (ainda **não publicado**) tem a mensagem `wip`. Troque a mensagem para `feat: adiciona login` **sem** criar um commit a mais e sem mudar o conteúdo.

### 02 — Desfazer um commit já publicado · `02-desfazer-publicado.sh`
No repositório `app`, o commit com a mensagem `feat: cupom com bug` **já foi publicado** e outras pessoas baixaram. Desfaça o efeito dele (o arquivo `cupom.py` deve deixar de existir) **sem reescrever o histórico**: o commit com bug deve continuar no log e um commit novo deve desfazê-lo. Não abra editor (use a opção que aceita a mensagem padrão).

Atenção: o commit com bug **não é o último** do histórico.

### 03 — Branch apagada por engano · `03-recuperar-branch.sh`
No repositório `app` alguém criou a branch `experimento`, fez um commit `exp: ideia ousada`, voltou para a `main` e **apagou** a branch com `git branch -D`. Recrie a branch `experimento` apontando para aquele commit.

Dica: o `reflog` guarda por onde o `HEAD` passou.

<sub>© 2026 Prof. Daniel Santos · CC BY-NC-SA 4.0</sub>
