# 🏋️ Exercícios — Módulo 08

Edite os arquivos `.sh` desta pasta e corrija com:

```bash
./ferramentas/corrigir.sh 08        # todos do módulo
./ferramentas/corrigir.sh 08 01     # só o exercício 01
```

Tags, versões e notas de release. O corretor verifica o **tipo** de tag (anotada × leve), para onde ela aponta e a saída dos seus scripts.

O corretor roda cada script numa **pasta temporária vazia**, com identidade Git fixa (`Aluno Git <aluno@curso.dev>`) e branch inicial `main` — você não precisa configurar nada para os exercícios funcionarem. Travou? As soluções comentadas estão em [solucoes/](solucoes/). Tente pelo menos 15 minutos antes de abrir.

---

### 01 — Marcar uma release antiga · `01-tag-anotada.sh`
No repositório `lib`, crie a tag **anotada** `v1.3.1` com a mensagem `Release 1.3.1` apontando para o commit cujo assunto é `fix: corrige arredondamento` (que **não** é o último commit).

### 02 — Qual é a última versão? · `02-ultima-versao.sh`
O repositório `lib` tem as tags `v1.2.0`, `v1.9.3`, `v1.10.0` e `v1.10.1`, além de uma tag `nightly`. Imprima **somente** a tag de **maior versão** no padrão `vX.Y.Z` (aqui, `v1.10.1`). Atenção: ordenar como texto dá a resposta errada.

### 03 — Notas da versão · `03-notas-da-versao.sh`
No repositório `app`, imprima as **novidades** (commits `feat`) entre as tags `v1.0.0` e `v1.1.0`, **sem** o prefixo `feat:`/`feat(escopo):`, do mais antigo para o mais novo, um por linha. Para o repositório dos testes, a saída é:
```
calcula frete por CEP
cupom de desconto
```

<sub>© 2026 Prof. Daniel Santos · CC BY-NC-SA 4.0</sub>
