# Módulo 05 · Conflitos

> **Você vai sair daqui sabendo:** por que conflitos acontecem (e por que são normais), ler os marcadores de conflito, resolver com calma — à mão, escolhendo um lado ou com ferramenta —, desistir com segurança e fazer o Git **lembrar** como você resolveu.

⏱ 3–4 h · 🧪 [Time simulado](../../laboratorio/#opção-c--time-simulado-sem-internet-sem-conta) · ✍️ [Exercícios](exercicios/)

---

## 1. Cenário

Ana mudou a taxa de imposto de `0.12` para `0.15`. Ao mesmo tempo, Bia mudou a **mesma linha** para `0.18`. O Git não tem como saber qual é a certa — essa é uma decisão de negócio, não de software. Ele para e pede a você. Isso é um **conflito**: não é erro, é o Git sendo honesto.

## 2. Quando há conflito (e quando não há)

No merge de três vias (Módulo 04), o Git compara o **ancestral comum** com as duas pontas:

| Ancestral | Lado A (main) | Lado B (feature) | Resultado |
|---|---|---|---|
| X | X | Y | Y (só B mudou) |
| X | Y | X | Y (só A mudou) |
| X | Y | Y | Y (mudaram igual) |
| X | Y | Z | **conflito** |

Também geram conflito: um lado **apaga** o arquivo e o outro **edita** (*modify/delete*), e os dois **criam** arquivos diferentes com o mesmo nome (*add/add*). Mudanças em **linhas diferentes** do mesmo arquivo normalmente se combinam sozinhas.

Conflitos podem surgir em `merge`, `rebase`, `cherry-pick`, `revert`, `stash pop` e `pull` — a resolução é sempre a mesma.

## 3. Anatomia de um conflito

```text
MOEDA=BRL
<<<<<<< HEAD
TAXA=0.15
||||||| ancestral
TAXA=0.12
=======
TAXA=0.18
>>>>>>> feature/imposto
```

| Marcador | Significa |
|---|---|
| `<<<<<<< HEAD` | começa a versão da branch em que você está (“nossa”, *ours*) |
| `\|\|\|\|\|\|\| ancestral` | a versão **original** (só aparece com `merge.conflictStyle = diff3` ou `zdiff3`) |
| `=======` | divide os lados |
| `>>>>>>> feature/imposto` | termina a versão que está chegando (“deles”, *theirs*) |

> 💡 Ative `git config --global merge.conflictStyle zdiff3` (Git 2.35+). Ver o **original** muda tudo: você entende o que **cada lado quis fazer**, não só o resultado.

## 4. Roteiro de resolução

```bash
git merge feature/imposto          # CONFLICT (content): Merge conflict in config.ini
git status                         # “both modified: config.ini”
# 1. abra o arquivo, decida o conteúdo final e APAGUE os marcadores
# 2. avise o Git que resolveu:
git add config.ini
# 3. conclua:
git commit                         # (no rebase: git rebase --continue)
```

| Quero… | Comando |
|---|---|
| ver só os arquivos em conflito | `git diff --name-only --diff-filter=U` |
| ficar com a **minha** versão do arquivo inteiro | `git checkout --ours arquivo` (ou `git restore --ours arquivo`) |
| ficar com a versão **que chega** | `git checkout --theirs arquivo` |
| usar uma ferramenta visual | `git mergetool` (configure: `git config --global merge.tool vscode`) |
| desistir e voltar ao estado anterior | `git merge --abort` · `git rebase --abort` · `git cherry-pick --abort` |
| resolver automaticamente a favor de um lado | `git merge -X ours feature` · `-X theirs` (só nos trechos em conflito!) |

> ⚠️ `-X ours` (opção da estratégia) ≠ `-s ours` (estratégia): o primeiro só decide os **trechos em conflito** e traz o resto da outra branch; o segundo **ignora a outra branch inteira**. Quase sempre você quer o primeiro — ou nenhum dos dois.

> ⚠️ No **rebase**, os papéis se invertem: `--ours` é a branch onde você está reaplicando (a base) e `--theirs` são os **seus** commits sendo reaplicados.

## 5. `rerere`: reuse recorded resolution

Com `git config --global rerere.enabled true`, o Git grava cada resolução que você faz e, quando o **mesmo** conflito aparecer de novo (comum em rebases repetidos ou branches de longa duração), aplica sozinho. Você só revisa e confirma.

## 6. Como ter menos conflitos

- Integre a `main` na sua branch (ou faça rebase) **com frequência** — conflitos pequenos e cedo são fáceis.
- Branches curtas; PRs pequenos.
- Formatação automática no time (todos com o mesmo formatador) — evita conflitos de espaço e quebra de linha.
- `.gitattributes` para arquivos gerados (ex.: `package-lock.json merge=ours` em casos específicos) e para fim de linha.
- Combine responsabilidades: duas pessoas reescrevendo o mesmo arquivo ao mesmo tempo é um problema de organização, não de Git.

## 7. Mão na massa

| Exemplo | O que demonstra |
|---|---|
| [`01-anatomia.sh`](exemplos/01-anatomia.sh) | provocar um conflito, ler os marcadores com `zdiff3`, resolver e concluir |
| [`02-ours-theirs-abort.sh`](exemplos/02-ours-theirs-abort.sh) | escolher um lado por arquivo, `-X ours`/`-X theirs` e `merge --abort` |
| [`03-rerere.sh`](exemplos/03-rerere.sh) | o Git resolvendo sozinho um conflito que você já resolveu antes |

## 8. Exercícios

[exercicios/README.md](exercicios/) · `./ferramentas/corrigir.sh 05`

## 9. Boas práticas e armadilhas

- ✅ Depois de resolver, **rode os testes** antes do commit: um merge sem conflito ainda pode quebrar o programa (mudanças compatíveis no texto, incompatíveis na lógica).
- ✅ Na dúvida, pergunte a quem fez o outro lado — `git log --merge -p arquivo` mostra os commits envolvidos no conflito.
- ⚠️ `git add` com marcadores ainda no arquivo **conclui** o conflito com lixo dentro. Procure antes: `git diff --check` acusa marcadores esquecidos.
- ⚠️ Não resolva conflito apagando o trabalho do colega para “fazer passar”.

## 📚 Fontes oficiais

- Pro Git: [3.2 Conflitos básicos de mesclagem](https://git-scm.com/book/pt-br/v2/Ramifica%c3%a7%c3%a3o-Branching-no-Git-Ramifica%c3%a7%c3%a3o-Branching-e-Mesclagem-Merging-B%c3%a1sicas) · [7.8 Merging avançado](https://git-scm.com/book/pt-br/v2/Ferramentas-do-Git-Merging-Avan%c3%a7ado) · [7.9 Rerere](https://git-scm.com/book/pt-br/v2/Ferramentas-do-Git-Rerere)
- Manual: [git-merge (HOW CONFLICTS ARE PRESENTED)](https://git-scm.com/docs/git-merge#_how_conflicts_are_presented) · [git-mergetool](https://git-scm.com/docs/git-mergetool) · [git-rerere](https://git-scm.com/docs/git-rerere) · [merge-strategies](https://git-scm.com/docs/merge-strategies)

---

⬅️ [Módulo 04](../04-branches-e-merge/) · ➡️ [Módulo 06 · Remotos e colaboração](../06-remotos-e-colaboracao/)

<sub>© 2026 Prof. Daniel Santos · conteúdo [CC BY-NC-SA 4.0](../../LICENSE-CONTEUDO.md) · código [PolyForm Noncommercial](../../LICENSE)</sub>
