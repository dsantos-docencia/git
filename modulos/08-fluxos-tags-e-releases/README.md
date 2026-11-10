# Módulo 08 · Fluxos, tags e releases

> **Você vai sair daqui sabendo:** escolher um fluxo de trabalho para o time (GitHub flow, Git Flow, trunk-based), escrever commits que viram changelog (Conventional Commits), versionar com SemVer, criar e publicar **tags**, e fechar uma release de ponta a ponta.

⏱ 4–5 h · 🧰 [Scripts de release](../../scripts/release/) · ✍️ [Exercícios](exercicios/)

---

## 1. Cenário

A loja vai lançar a versão 1.4. A gerente pergunta: “o que entra?”, “dá para corrigir um bug da 1.3 sem levar as novidades?”, “como o cliente sabe o que mudou?”. As respostas dependem de três combinados do time: **como as branches circulam** (fluxo), **como os commits são escritos** e **como as versões são numeradas e marcadas**.

## 2. Fluxos de trabalho

| Fluxo | Como funciona | Bom para | Cuidado |
|---|---|---|---|
| **GitHub flow** | `main` sempre publicável; cada mudança numa branch curta → Pull Request → revisão → merge → deploy | web/SaaS com deploy contínuo | precisa de CI confiável |
| **Trunk-based** | todos integram na `main` (tronco) pelo menos diariamente; branches de horas; funcionalidades incompletas atrás de *feature flags* | times maduros, alta frequência de entrega | disciplina de testes e flags |
| **Git Flow** | `main` (produção) + `develop` (integração) + `feature/*`, `release/*`, `hotfix/*` | software com versões mantidas em paralelo (apps instalados, bibliotecas) | pesado para deploy contínuo — o próprio autor recomenda avaliar o GitHub flow nesses casos |
| **Release branches** | `main` + `release/1.x`, `release/2.x` recebendo *cherry-picks* de correções | manter versões antigas com suporte | o cherry-pick precisa de rastreio (`-x`) |

> 🧭 Regra prática: comece com **GitHub flow**. Só adote algo mais complexo quando um problema real pedir (ex.: suportar a 1.x e a 2.x ao mesmo tempo).

## 3. Conventional Commits

```text
<tipo>[escopo opcional][!]: <descrição>

[corpo opcional]

[rodapé(s) opcional(is)]   ex.: BREAKING CHANGE: …   Refs: #142
```

| Tipo | Uso | Efeito na versão |
|---|---|---|
| `feat` | nova funcionalidade | MINOR |
| `fix` | correção | PATCH |
| `perf` | desempenho | PATCH |
| `docs`, `style`, `refactor`, `test`, `build`, `ci`, `chore` | o resto | nenhum |
| `!` após o tipo ou `BREAKING CHANGE:` no rodapé | quebra compatibilidade | **MAJOR** |

Ganhos: changelog automático, versão calculada, histórico pesquisável (`git log --grep '^fix'`). O hook [`scripts/hooks/commit-msg.sh`](../../scripts/hooks/commit-msg.sh) impõe o padrão no time.

## 4. Versionamento semântico (SemVer)

`MAJOR.MINOR.PATCH` — por exemplo `2.4.1`:

- **MAJOR**: mudanças incompatíveis (quem usa precisa adaptar);
- **MINOR**: funcionalidades novas compatíveis;
- **PATCH**: correções compatíveis.

Pré-lançamentos: `2.0.0-rc.1`, `2.0.0-beta.2`. Antes da 1.0.0, “tudo pode mudar”.

## 5. Tags

| Tipo | Comando | O que guarda |
|---|---|---|
| **leve** | `git tag v1.4.0` | só um ponteiro (como uma branch que não anda) |
| **anotada** (recomendada para releases) | `git tag -a v1.4.0 -m "Release 1.4.0"` | objeto próprio: autor, data, mensagem (e assinatura com `-s`) |

```bash
git tag -a v1.3.1 a1b2c3d -m "Release 1.3.1"   # marcar um commit antigo
git tag -l "v1.*" --sort=-v:refname            # lista em ordem de VERSÃO (1.10 > 1.9)
git show v1.4.0                                # metadados da tag + commit
git push origin v1.4.0                         # tags NÃO sobem com o push normal
git push --follow-tags                         # sobe commits + tags anotadas alcançáveis
git describe --tags                            # v1.4.0-3-g9f8e7d6 = 3 commits depois da v1.4.0
git tag -d v1.4.0 && git push origin --delete v1.4.0   # apagar (evite em tags publicadas)
```

> ⚠️ **Não mova tag publicada.** Quem já baixou fica com a antiga. Errou a release? Lance a próxima (`v1.4.1`).

## 6. Fechando uma release (receita)

```bash
git switch main && git pull --ff-only
bash scripts/release/proxima-versao.sh                 # → v1.4.0  (pelos Conventional Commits)
bash scripts/release/gerar-changelog.sh > NOTAS.md     # notas agrupadas por tipo
bash scripts/release/proxima-versao.sh --tag           # cria a tag anotada
git push --follow-tags
# na plataforma: criar a Release a partir da tag, colando o NOTAS.md
```

Nos cursos das plataformas você automatiza isto no CI (GitHub Actions, GitLab CI, Bitbucket Pipelines).

## 7. Mão na massa

| Exemplo | O que demonstra |
|---|---|
| [`01-tags.sh`](exemplos/01-tags.sh) | tag leve × anotada, ordem por versão, `describe`, push de tags |
| [`02-github-flow.sh`](exemplos/02-github-flow.sh) | o ciclo branch → (PR) → merge → tag, com servidor local |
| [`03-release-automatica.sh`](exemplos/03-release-automatica.sh) | Conventional Commits → próxima versão → changelog → tag, com os scripts do curso |

## 8. Exercícios

[exercicios/README.md](exercicios/) · `./ferramentas/corrigir.sh 08`

## 9. Boas práticas e armadilhas

- ✅ Tags anotadas para releases; leves só para marcações pessoais.
- ✅ Proteja tags `v*` na plataforma (só a pipeline ou mantenedores criam).
- ✅ O changelog é para **pessoas**: o gerado automaticamente é um rascunho — revise.
- ⚠️ `git tag -l | sort` ordena como texto (`v1.10` antes de `v1.9`). Use `--sort=-v:refname`.

## 📚 Fontes oficiais

- Pro Git: [2.6 Criando tags](https://git-scm.com/book/pt-br/v2/Fundamentos-do-Git-Criando-Tags) · [3.4 Fluxos de trabalho de branches](https://git-scm.com/book/pt-br/v2/Ramifica%c3%a7%c3%a3o-Branching-no-Git-Fluxos-de-Trabalho-de-Branches-Branching-Workflows) · [5.3 Mantendo um projeto](https://git-scm.com/book/pt-br/v2/Git-Distribu%c3%addo-Mantendo-um-Projeto)
- Manual: [git-tag](https://git-scm.com/docs/git-tag) · [git-describe](https://git-scm.com/docs/git-describe) · [gitworkflows](https://git-scm.com/docs/gitworkflows)
- [Conventional Commits 1.0.0 (pt-br)](https://www.conventionalcommits.org/pt-br/v1.0.0/) · [SemVer 2.0.0 (pt-BR)](https://semver.org/lang/pt-BR/) · [GitHub flow](https://docs.github.com/pt/get-started/using-github/github-flow) · [Git Flow (artigo original)](https://nvie.com/posts/a-successful-git-branching-model/) · [Trunk Based Development](https://trunkbaseddevelopment.com/)

---

⬅️ [Módulo 07](../07-reescrevendo-o-historico/) · ➡️ [Módulo 09 · Ferramentas avançadas](../09-ferramentas-avancadas/)

<sub>© 2026 Prof. Daniel Santos · conteúdo [CC BY-NC-SA 4.0](../../LICENSE-CONTEUDO.md) · código [PolyForm Noncommercial](../../LICENSE)</sub>
