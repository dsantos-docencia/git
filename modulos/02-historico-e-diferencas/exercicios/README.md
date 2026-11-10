# 🏋️ Exercícios — Módulo 02

Edite os arquivos `.sh` desta pasta e corrija com:

```bash
./ferramentas/corrigir.sh 02        # todos do módulo
./ferramentas/corrigir.sh 02 01     # só o exercício 01
```

Os testes montam um repositório chamado `historico` na pasta onde o seu script roda. Seu script só **lê** esse repositório e imprime a resposta.

O corretor roda cada script numa **pasta temporária vazia**, com identidade Git fixa (`Aluno Git <aluno@curso.dev>`) e branch inicial `main` — você não precisa configurar nada para os exercícios funcionarem. Travou? As soluções comentadas estão em [solucoes/](solucoes/). Tente pelo menos 15 minutos antes de abrir.

---

### 01 — Quantos commits? · `01-contar-commits.sh`
Existe um repositório `historico` na pasta atual. Imprima **somente o número** de commits alcançáveis a partir de `HEAD`. Use um comando de encanamento (o resultado não deve depender de formatação).

### 02 — Quem mudou a taxa? · `02-quem-mudou-a-taxa.sh`
No repositório `historico`, a linha `TAXA=0.15` apareceu em algum commit. Imprima **apenas o assunto** (primeira linha da mensagem) **desse** commit.

Dica: o *pickaxe* (`git log -S`) encontra commits que adicionaram ou removeram um texto.

### 03 — O que mudou desde a v1.0? · `03-o-que-mudou-desde.sh`
Imprima a lista de **arquivos** alterados entre a tag `v1.0` e o `HEAD` do repositório `historico`, um por linha, em ordem alfabética:
```
app.py
config.ini
docs/uso.md
```

<sub>© 2026 Prof. Daniel Santos · CC BY-NC-SA 4.0</sub>
