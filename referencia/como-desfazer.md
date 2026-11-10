# 🛟 Como desfazer — por situação

Primeiro responda: **isso já foi publicado (push) e alguém pode ter baixado?** Se sim, use só os comandos marcados como ✅ seguros para histórico público.

![Mapa de como desfazer](../assets/mapa-desfazer.svg)

| # | Situação | Comando | Público? |
|---|---|---|---|
| 1 | Editei um arquivo e quero voltar ao último commit | `git restore arquivo` | ✅ (não mexe no histórico) |
| 2 | Dei `git add` sem querer | `git restore --staged arquivo` | ✅ |
| 3 | Quero a versão do arquivo de 3 commits atrás | `git restore --source=HEAD~3 arquivo` | ✅ |
| 4 | Errei a mensagem do último commit | `git commit --amend -m "nova"` | ❌ só local |
| 5 | Esqueci um arquivo no último commit | `git add arq && git commit --amend --no-edit` | ❌ só local |
| 6 | Quero desfazer o último commit mas manter as mudanças | `git reset --soft HEAD~1` | ❌ só local |
| 7 | Quero jogar fora os últimos 2 commits e as mudanças | `git reset --hard HEAD~2` | ❌ só local · ⚠️ |
| 8 | Um commit publicado quebrou produção | `git revert <commit>` | ✅ |
| 9 | Um **merge** publicado precisa sair | `git revert -m 1 <merge>` | ✅ |
| 10 | Commitei na branch errada (não publicado) | `git switch -c certa` → `git switch errada` → `git reset --hard HEAD~1` | ❌ só local |
| 11 | Apaguei uma branch | `git reflog` → `git branch nome <hash>` | — |
| 12 | Fiz `reset --hard` errado | `git reset --hard HEAD@{1}` | — |
| 13 | Rebase deu errado | `git rebase --abort` (durante) · `git reset --hard ORIG_HEAD` (logo depois) | — |
| 14 | Merge com conflitos e quero desistir | `git merge --abort` | — |
| 15 | Arquivos lixo não rastreados | `git clean -n` → `git clean -fd` | — · ⚠️ apaga |
| 16 | Commitei uma senha | **troque a senha já**; depois `git filter-repo` e force-push combinado com o time | ⚠️ |
| 17 | Quero guardar o que estou fazendo e limpar a área | `git stash push -m "descrição"` | — |
| 18 | Quero desfazer um `git add .` enorme | `git reset` (sem argumentos) | ✅ |

> Quase tudo que foi **commitado** pode ser recuperado pelo `reflog` por ~90 dias. O que não foi commitado nem guardado em stash, não.

📚 [Pro Git 2.4 — Desfazendo coisas](https://git-scm.com/book/pt-br/v2/Fundamentos-do-Git-Desfazendo-Coisas) · [7.7 — Reset desmistificado](https://git-scm.com/book/pt-br/v2/Ferramentas-do-Git-Reset-Desmistificado)

<sub>© 2026 Prof. Daniel Santos · CC BY-NC-SA 4.0</sub>
