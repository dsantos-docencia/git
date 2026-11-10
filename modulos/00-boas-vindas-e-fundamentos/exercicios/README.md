# 🏋️ Exercícios — Módulo 00

Edite os arquivos `.sh` desta pasta e corrija com:

```bash
./ferramentas/corrigir.sh 00        # todos do módulo
./ferramentas/corrigir.sh 00 01     # só o exercício 01
```

Os exercícios deste módulo treinam instalação, configuração e o hábito de perguntar ao próprio Git.

O corretor roda cada script numa **pasta temporária vazia**, com identidade Git fixa (`Aluno Git <aluno@curso.dev>`) e branch inicial `main` — você não precisa configurar nada para os exercícios funcionarem. Travou? As soluções comentadas estão em [solucoes/](solucoes/). Tente pelo menos 15 minutos antes de abrir.

---

### 01 — Identidade local · `01-identidade.sh`
Crie um repositório chamado `projeto` (branch inicial `main`) e configure, **somente no nível local** desse repositório:
- `user.name` = `Aluno Git`
- `user.email` = `aluno@curso.dev`

Dica: dentro do repositório, `git config` sem opção já grava no nível local — mas escreva `--local` para deixar a intenção explícita.

### 02 — Só o número da versão · `02-versao.sh`
`git --version` imprime algo como `git version 2.56.0` (no Windows, `git version 2.56.0.windows.1`). Faça o script imprimir **apenas** os três números, por exemplo:
```
2.56.0
```

### 03 — De onde vem esta configuração? · `03-de-onde-vem.sh`
Crie o repositório `projeto`, defina **localmente** `core.editor` como `nano` e então imprima **uma linha** com o **escopo** e o **valor** efetivo de `core.editor`, separados por tabulação — exatamente como o Git mostra com `--show-scope`:
```
local	nano
```

<sub>© 2026 Prof. Daniel Santos · CC BY-NC-SA 4.0</sub>
