# Módulo 03 · Desfazendo com segurança

> **Você vai sair daqui sabendo:** desfazer qualquer coisa no Git escolhendo a ferramenta certa — `restore`, `commit --amend`, `reset`, `revert`, `clean` — e recuperar o que parecia perdido com o `reflog`. Tudo guiado por uma pergunta: **isso já foi publicado?**

⏱ 4–5 h · ✍️ [Exercícios](exercicios/)

---

## 1. Cenário

Três situações reais da mesma semana:

1. Você editou o arquivo errado e quer jogar a edição fora.
2. Commitou com a mensagem `wip` e esqueceu um arquivo — ainda não fez `push`.
3. Um commit com bug **já foi para o servidor** e outras pessoas já baixaram.

Cada uma pede uma ferramenta diferente. Usar a errada no caso 3 (reescrever histórico público) é a forma mais rápida de estragar o dia do time inteiro.

## 2. O mapa

![Mapa de como desfazer](../../assets/mapa-desfazer.svg)

| Situação | Comando | Reescreve histórico? |
|---|---|---|
| Descartar edição no arquivo (sem `add`) | `git restore arquivo` | não (mas **perde** a edição) |
| Tirar da preparação, manter a edição | `git restore --staged arquivo` | não |
| Voltar o arquivo à versão de um commit | `git restore --source=HEAD~2 arquivo` | não |
| Corrigir o **último** commit (mensagem ou arquivos) | `git commit --amend` | **sim** — só se não publicado |
| Desfazer commits **locais** | `git reset --soft/--mixed/--hard <commit>` | **sim** — só se não publicado |
| Desfazer commit **publicado** | `git revert <commit>` | não — cria um commit novo |
| Apagar arquivos não rastreados | `git clean -n` (simula) → `git clean -f` | não (mas apaga de verdade) |
| Recuperar commit/branch “perdido” | `git reflog` + `git branch`/`reset` | — |

> 🧭 **Regra de ouro:** só reescreva (amend, reset, rebase) commits que **ainda não saíram da sua máquina**. Depois do `push`, use `revert`.

## 3. `restore`: arquivos

Desde o Git 2.23, `git restore` (arquivos) e `git switch` (branches) dividem o trabalho do antigo `git checkout`, que fazia as duas coisas e confundia.

```bash
git restore app.py                    # descarta a edição (volta ao que está na preparação)
git restore --staged app.py           # "desfaz o add"
git restore --staged --worktree app.py  # volta ao último commit, nas duas áreas
git restore --source=v1.0 app.py      # traz a versão da tag v1.0 para o diretório de trabalho
```

⚠️ `git restore arquivo` **não tem desfazer**: a edição não estava em nenhum commit.

## 4. `commit --amend`: consertar o último commit

```bash
git add arquivo-esquecido.py
git commit --amend --no-edit          # inclui o arquivo, mantém a mensagem
git commit --amend -m "feat: adiciona login"   # troca a mensagem
```

O amend **cria um commit novo** (hash diferente) e descarta o antigo. Por isso não se faz amend em commit publicado.

## 5. `reset`: mover a branch para trás

`git reset <commit>` move a branch atual para `<commit>`. A diferença entre os modos é **o que acontece com as mudanças** dos commits “desfeitos”:

| Modo | Branch | Preparação | Diretório de trabalho | Use quando |
|---|---|---|---|---|
| `--soft` | volta | mantém as mudanças **preparadas** | mantém | refazer os últimos commits como um só |
| `--mixed` (padrão) | volta | limpa | mantém as mudanças | reorganizar o que vai em cada commit |
| `--hard` | volta | limpa | **descarta** | jogar tudo fora (cuidado!) |

```bash
git reset --soft HEAD~3    # junta os 3 últimos commits numa preparação só
git reset HEAD~1           # desfaz o último commit, edições ficam no disco
git reset --hard origin/main   # “igual ao servidor”, descartando tudo local
```

Leitura recomendada e didática: [Reset desmistificado](https://git-scm.com/book/pt-br/v2/Ferramentas-do-Git-Reset-Desmistificado) (Pro Git 7.7).

## 6. `revert`: desfazer em público

`git revert <commit>` cria um **novo** commit com o inverso das mudanças. O histórico continua verdadeiro (o erro e a correção ficam registrados) e ninguém que já baixou precisa fazer nada especial.

```bash
git revert a1b2c3d                 # abre o editor com "Revert ..."
git revert --no-edit HEAD          # sem editor
git revert -m 1 <commit-de-merge>  # reverter um merge: -m diz qual pai é a "linha principal"
git revert --no-commit A..B        # vários commits num revert só
```

## 7. `reflog`: a rede de segurança

O Git anota **toda** movimentação de `HEAD` e das branches por ~90 dias (configurável em `gc.reflogExpire`). Um commit “apagado” por `reset --hard` ou uma branch removida com `branch -D` continuam no repositório até o coletor de lixo agir.

```bash
git reflog                          # histórico de onde o HEAD esteve
git reflog show feature             # o mesmo, para uma branch
git branch recuperada HEAD@{3}      # recria uma branch apontando para aquele ponto
git reset --hard HEAD@{1}           # desfaz um reset/rebase recém-feito
```

> 🛟 Quase nada que foi **commitado** se perde no Git. O que se perde de verdade é o que **nunca** foi commitado — por isso, commit cedo e com frequência (no máximo, junte depois com `reset --soft`).

## 8. `clean`: arquivos não rastreados

```bash
git clean -n          # SIMULA: lista o que seria apagado
git clean -fd         # apaga arquivos e pastas não rastreados
git clean -fdx        # inclui os IGNORADOS (build/, node_modules/) — “fábrica”
git clean -i          # modo interativo
```

## 9. Mão na massa

| Exemplo | O que demonstra |
|---|---|
| [`01-restore-e-amend.sh`](exemplos/01-restore-e-amend.sh) | descartar edição, “desfazer o add” e consertar o último commit |
| [`02-reset-tres-modos.sh`](exemplos/02-reset-tres-modos.sh) | `--soft`, `--mixed` e `--hard` lado a lado, e `revert` |
| [`03-reflog-salva-vidas.sh`](exemplos/03-reflog-salva-vidas.sh) | recuperar commits após `reset --hard` e uma branch apagada |

## 10. Exercícios

[exercicios/README.md](exercicios/) · `./ferramentas/corrigir.sh 03`

## 11. Boas práticas e armadilhas

- ✅ Antes de um `reset --hard` ou `clean -f`, rode `git status` e `git stash` (Módulo 09) se tiver dúvida.
- ✅ Em branch compartilhada, a única forma educada de desfazer é `revert`.
- ✅ Configure o servidor para **bloquear force-push** na branch principal (cursos de GitHub/GitLab/Bitbucket).
- ⚠️ `git checkout -- arquivo` ainda funciona e faz o mesmo que `git restore arquivo` — você vai encontrar em tutoriais antigos.
- ⚠️ O reflog é **local**: não vai para o servidor e não existe num clone novo.

## 📚 Fontes oficiais

- Pro Git: [2.4 Desfazendo coisas](https://git-scm.com/book/pt-br/v2/Fundamentos-do-Git-Desfazendo-Coisas) · [7.7 Reset desmistificado](https://git-scm.com/book/pt-br/v2/Ferramentas-do-Git-Reset-Desmistificado) · [10.7 Manutenção e recuperação de dados](https://git-scm.com/book/pt-br/v2/Git-Internals-Por-Dentro-do-Git-Manuten%c3%a7%c3%a3o-e-Recupera%c3%a7%c3%a3o-de-Dados)
- Manual: [git-restore](https://git-scm.com/docs/git-restore) · [git-reset](https://git-scm.com/docs/git-reset) · [git-revert](https://git-scm.com/docs/git-revert) · [git-reflog](https://git-scm.com/docs/git-reflog) · [git-clean](https://git-scm.com/docs/git-clean) · [git-commit (--amend)](https://git-scm.com/docs/git-commit)

---

⬅️ [Módulo 02](../02-historico-e-diferencas/) · ➡️ [Módulo 04 · Branches e merge](../04-branches-e-merge/)

<sub>© 2026 Prof. Daniel Santos · conteúdo [CC BY-NC-SA 4.0](../../LICENSE-CONTEUDO.md) · código [PolyForm Noncommercial](../../LICENSE)</sub>
