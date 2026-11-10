# Módulo 09 · Ferramentas avançadas

> **Você vai sair daqui sabendo:** guardar trabalho pela metade (`stash`), trabalhar em duas branches ao mesmo tempo (`worktree`), achar o commit que introduziu um bug em minutos (`bisect`), lidar com repositórios dentro de repositórios (submódulos e subtree), clonar só o que precisa (sparse checkout e clone parcial) e versionar arquivos grandes (Git LFS).

⏱ 5–6 h · ✍️ [Exercícios](exercicios/)

---

## 1. Cenário

Você está no meio do login quando chega o chamado: produção quebrou, e o relatório de vendas parou de funcionar “em algum momento das últimas 200 alterações”. Você precisa largar o que está fazendo sem perder nada, abrir a versão de produção sem destruir seu ambiente e encontrar o culpado — rápido.

## 2. `stash`: a gaveta

```bash
git stash push -m "meio do login"      # guarda mudanças rastreadas e limpa a área
git stash push -u -m "com novos"       # -u: inclui arquivos NÃO rastreados
git stash list                         # stash@{0}: On feature/login: meio do login
git stash show -p stash@{0}            # o que tem dentro
git stash pop                          # aplica e remove da gaveta
git stash apply stash@{1}              # aplica e MANTÉM na gaveta
git stash branch nova-branch           # cria uma branch a partir do stash (evita conflitos)
git stash drop stash@{0}               # descarta
```

> ⚠️ Stash é para **horas**, não semanas. Trabalho que vai durar? Commit numa branch.

## 3. `worktree`: duas branches abertas ao mesmo tempo

```bash
git worktree add ../loja-hotfix -b hotfix/relatorio main   # nova pasta, nova branch, mesmo repositório
git worktree list
git worktree remove ../loja-hotfix
```

Diferente de clonar de novo: compartilha os objetos (sem baixar nada) e as branches. Ótimo para revisar um PR enquanto o build da sua branch roda.

## 4. `bisect`: busca binária no histórico

Entre um commit **bom** e um **ruim**, o Git testa o do meio, depois o meio da metade… Com 200 commits, são no máximo **8 testes** (log₂ 200).

```bash
git bisect start
git bisect bad                 # o atual está quebrado
git bisect good v1.3.0         # esta versão funcionava
# o Git faz checkout de um commit no meio; você testa e responde:
git bisect good   # ou: git bisect bad
# … até: "a1b2c3d is the first bad commit"
git bisect reset               # volta para onde estava
```

**Automático:** com um script que sai com 0 (bom) ou 1–124 (ruim):

```bash
git bisect start HEAD v1.3.0
git bisect run ./testes/relatorio.sh     # o Git roda o teste em cada passo sozinho
```

> 🧠 O bisect só funciona bem se **cada commit compila e passa nos testes** — mais um motivo para commits pequenos e para `rebase -i --exec` (Módulo 07).

## 5. Repositório dentro de repositório

| | Submódulo | Subtree |
|---|---|---|
| Como fica | o repositório pai guarda **um ponteiro** (commit) para o outro | o código do outro é **copiado** para uma pasta |
| Clonar | `git clone --recurse-submodules` (ou `git submodule update --init --recursive`) | normal |
| Atualizar | `git submodule update --remote` | `git subtree pull --prefix=libs/x <url> main --squash` |
| Bom para | dependências versionadas independentemente | quem usa não precisa saber que há outro repositório |
| Armadilha | esquecer o `--recurse-submodules`; ponteiro desatualizado | histórico misturado |

```bash
git submodule add https://exemplo.com/lib-pagamentos.git libs/pagamentos
cat .gitmodules
```

Em muitos projetos, um **gerenciador de pacotes** (npm, pip, NuGet, Maven) resolve melhor que os dois.

## 6. Repositórios grandes

| Técnica | Comando | Efeito |
|---|---|---|
| clone raso | `git clone --depth 1 <url>` | só o último commit (CI, builds) |
| clone parcial | `git clone --filter=blob:none <url>` | todo o histórico, mas baixa o conteúdo dos arquivos sob demanda |
| sparse checkout | `git sparse-checkout set apps/web libs/ui` | só essas pastas no diretório de trabalho (monorepos) |
| manutenção | `git maintenance start` | tarefas periódicas (gc, commit-graph, prefetch) |

## 7. Git LFS: arquivos grandes

Vídeos, PSDs, modelos de ML e dumps não combinam com o Git comum: cada versão fica para sempre no histórico de todo clone. O **Git LFS** guarda no repositório só um ponteiro de texto e o arquivo em si num armazenamento separado (as plataformas oferecem).

```bash
git lfs install                 # uma vez por máquina
git lfs track "*.psd"           # grava a regra no .gitattributes — versione-o!
git add .gitattributes arte.psd && git commit -m "feat: arte da campanha"
git lfs ls-files
git lfs migrate import --include="*.zip"   # converter histórico existente (reescreve!)
```

Limites de armazenamento e banda do LFS variam por plataforma — veja os cursos de GitHub, GitLab e Bitbucket.

## 8. Mão na massa

| Exemplo | O que demonstra |
|---|---|
| [`01-stash-e-worktree.sh`](exemplos/01-stash-e-worktree.sh) | parar o trabalho no meio, atender um hotfix em outra pasta e voltar |
| [`02-bisect-automatico.sh`](exemplos/02-bisect-automatico.sh) | achar o commit culpado entre 40 com `bisect run` |
| [`03-submodulo-e-sparse.sh`](exemplos/03-submodulo-e-sparse.sh) | submódulo de ponta a ponta e sparse checkout num monorepo |

## 9. Exercícios

[exercicios/README.md](exercicios/) · `./ferramentas/corrigir.sh 09`

## 10. Boas práticas e armadilhas

- ✅ Dê mensagem aos stashes (`-m`); `stash@{3}` sem descrição não diz nada uma semana depois.
- ✅ Escreva o teste do `bisect run` antes de começar a caçar.
- ⚠️ `git stash` sem `-u` **não** guarda arquivos novos — eles continuam no disco.
- ⚠️ Não use `--depth 1` para desenvolver: `log`, `blame` e `bisect` ficam incompletos.

## 📚 Fontes oficiais

- Pro Git: [7.3 Stash e limpeza](https://git-scm.com/book/pt-br/v2/Ferramentas-do-Git-Fazendo-Stash-e-Limpando) · [7.10 Depurando com Git (bisect)](https://git-scm.com/book/pt-br/v2/Ferramentas-do-Git-Depurando-com-Git) · [7.11 Submódulos](https://git-scm.com/book/pt-br/v2/Ferramentas-do-Git-Subm%c3%b3dulos) · [7.12 Empacotando (bundle)](https://git-scm.com/book/pt-br/v2/Ferramentas-do-Git-Empacotando-Bundling)
- Manual: [git-stash](https://git-scm.com/docs/git-stash) · [git-worktree](https://git-scm.com/docs/git-worktree) · [git-bisect](https://git-scm.com/docs/git-bisect) · [git-submodule](https://git-scm.com/docs/git-submodule) · [git-sparse-checkout](https://git-scm.com/docs/git-sparse-checkout) · [partial-clone](https://git-scm.com/docs/partial-clone) · [git-maintenance](https://git-scm.com/docs/git-maintenance)
- [Git LFS](https://git-lfs.com/)

---

⬅️ [Módulo 08](../08-fluxos-tags-e-releases/) · ➡️ [Módulo 10 · Por dentro do Git](../10-por-dentro-do-git/)

<sub>© 2026 Prof. Daniel Santos · conteúdo [CC BY-NC-SA 4.0](../../LICENSE-CONTEUDO.md) · código [PolyForm Noncommercial](../../LICENSE)</sub>
