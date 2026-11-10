# 🏋️ Exercícios — Módulo 01

Edite os arquivos `.sh` desta pasta e corrija com:

```bash
./ferramentas/corrigir.sh 01        # todos do módulo
./ferramentas/corrigir.sh 01 01     # só o exercício 01
```

Aqui você monta repositórios com estados exatos — o corretor inspeciona commits, a área de preparação e o que está ignorado.

O corretor roda cada script numa **pasta temporária vazia**, com identidade Git fixa (`Aluno Git <aluno@curso.dev>`) e branch inicial `main` — você não precisa configurar nada para os exercícios funcionarem. Travou? As soluções comentadas estão em [solucoes/](solucoes/). Tente pelo menos 15 minutos antes de abrir.

---

### 01 — Primeiro commit · `01-primeiro-commit.sh`
Crie o repositório `projeto` com **um único commit** que contém o arquivo `README.md` com o conteúdo exato:
```
# Projeto
```
A mensagem do commit deve ser exatamente `docs: adiciona README`.

### 02 — Preparação seletiva · `02-preparacao-seletiva.sh`
Monte o repositório `projeto` neste estado final:
1. Um commit com **apenas** `a.txt` (conteúdo `versão 1`), mensagem `feat: adiciona a`.
2. `b.txt` existe no disco, mas **nunca** foi adicionado (não rastreado).
3. `a.txt` foi alterado para `versão 2` e essa alteração está **preparada**, mas **não commitada**.

O `git status --porcelain` deve mostrar exatamente:
```
M  a.txt
?? b.txt
```

### 03 — Ignorando o que não deve ser versionado · `03-gitignore.sh`
Crie o repositório `projeto` com um commit (mensagem livre) contendo **apenas** `.gitignore` e `app.py` (conteúdo livre). Depois do commit, crie também os arquivos `app.log`, `build/saida.bin` e `.env`.

Regras: o `.gitignore` precisa ignorar **qualquer** `.log`, a pasta `build/` e o `.env`. Ao final, `git status --porcelain` deve estar **vazio**.

<sub>© 2026 Prof. Daniel Santos · CC BY-NC-SA 4.0</sub>
