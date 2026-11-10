# Módulo 11 · Segurança, hooks e automação

> **Você vai sair daqui sabendo:** impedir que segredos entrem no repositório (e limpar o histórico quando entram), automatizar regras do time com **hooks**, padronizar o repositório com `.gitattributes`, **assinar** commits para provar autoria e usar o Git em pipelines de CI com segurança.

⏱ 4–5 h · 🧰 [Hooks prontos](../../scripts/hooks/) · ✍️ [Exercícios](exercicios/)

---

## 1. Cenário

Uma auditoria encontrou uma chave da AWS no repositório da loja — num commit de oito meses atrás, “apagada” no commit seguinte. A chave foi usada por terceiros. Além disso, commits apareceram com o nome de um desenvolvedor que estava de férias (qualquer um pode configurar `user.name` com qualquer nome). Este módulo fecha essas portas.

## 2. Segredos: prevenir, detectar, remediar

| Fase | Ferramenta | Como |
|---|---|---|
| **Prevenir** | `.gitignore` | `.env`, `*.pem`, `*.key` desde o primeiro commit (Módulo 01) |
| | hook `pre-commit` | bloqueia antes do commit: [`scripts/hooks/pre-commit.sh`](../../scripts/hooks/pre-commit.sh) |
| | plataforma | *push protection* / *secret detection* recusa o push (cursos das plataformas) |
| **Detectar** | varredura do histórico | [`scripts/auditoria/procurar-segredos.sh`](../../scripts/auditoria/procurar-segredos.sh) · [Gitleaks](https://github.com/gitleaks/gitleaks) |
| **Remediar** | 1º **revogar e trocar** a credencial | **sempre primeiro**: o segredo já pode ter sido copiado |
| | 2º reescrever o histórico | [`git filter-repo`](https://github.com/newren/git-filter-repo) (recomendado pela documentação do Git) |
| | 3º force-push combinado com o time | todos re-clonam; peça à plataforma para limpar caches/PRs antigos |

> ⚠️ Apagar o arquivo num commit novo **não** remove o segredo: ele continua em todos os clones, no histórico, para sempre (Módulo 10). Por isso a ordem é: **trocar a credencial**, depois limpar.

```bash
# remover um arquivo de TODO o histórico (instale: pip install git-filter-repo)
git filter-repo --path .env --invert-paths
# substituir um texto em todo o histórico
echo 'AKIAABCDEFGHIJKLMNOP==>REMOVIDO' > troca.txt && git filter-repo --replace-text troca.txt
```

`git filter-branch` ainda existe, mas a própria documentação desaconselha (lento e cheio de armadilhas). Você o verá em tutoriais antigos e no exemplo 03 (por não exigir instalação).

## 3. Hooks

Scripts que o Git executa em eventos. Ficam em `.git/hooks/` (não versionado) — ou numa pasta versionada indicada por `core.hooksPath`.

| Hook | Quando | Uso típico | Pode bloquear? |
|---|---|---|---|
| `pre-commit` | antes de criar o commit | lint, formatação, segredos, arquivos grandes | sim |
| `prepare-commit-msg` | antes de abrir o editor | pré-preencher a mensagem (ex.: número do ticket da branch) | sim |
| `commit-msg` | depois de escrever a mensagem | validar Conventional Commits | sim |
| `pre-push` | antes de enviar | rodar testes rápidos | sim |
| `post-checkout` / `post-merge` | depois de trocar de branch / mesclar | reinstalar dependências | não |
| `pre-receive` / `update` | **no servidor** | regras obrigatórias (as plataformas oferecem como “regras de proteção”) | sim |

```bash
mkdir .githooks && cp scripts/hooks/pre-commit.sh .githooks/pre-commit && chmod +x .githooks/pre-commit
git config core.hooksPath .githooks         # cada pessoa roda uma vez
git commit --no-verify                      # pula hooks locais (por isso regras críticas ficam no SERVIDOR/CI)
```

> 🧠 Hooks locais são **ajuda**, não **garantia**: qualquer um pode desligá-los. Regras obrigatórias vão para o servidor (branch protection, push rules) e para o CI. Para times, o framework [pre-commit](https://pre-commit.com/) gerencia hooks de várias linguagens.

## 4. `.gitattributes`: regras que viajam com o repositório

```gitattributes
* text=auto eol=lf          # normaliza fim de linha para LF no repositório
*.ps1 text eol=crlf         # scripts do Windows com CRLF
*.bat text eol=crlf
*.png binary                # sem diff textual, sem conversão
*.psd filter=lfs diff=lfs merge=lfs -text    # Git LFS (Módulo 09)
docs/** linguist-documentation              # estatísticas de linguagem nas plataformas
*.lock merge=ours           # estratégia de merge por arquivo (exige merge.ours.driver configurado)
```

Diferente do `core.autocrlf` (que depende da máquina), o `.gitattributes` vale para **todo mundo** que clona. Conferir: `git check-attr -a arquivo`. Depois de criar, normalize: `git add --renormalize .`.

## 5. Assinando commits

`user.name` e `user.email` são texto livre. Uma **assinatura** prova que o commit foi feito por quem tem a chave. Desde o Git 2.34 dá para assinar com a **mesma chave SSH** que você já usa:

```bash
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519.pub
git config --global commit.gpgsign true      # assina todo commit
git config --global tag.gpgsign true         # e toda tag
git log --show-signature -1
```

Para **verificar** localmente, o Git precisa de uma lista de chaves confiáveis (`gpg.ssh.allowedSignersFile`). Nas plataformas, cadastre a chave como *signing key*: os commits ganham o selo **Verified**, e dá para **exigir** commits assinados na branch protegida. GPG (`gpg.format openpgp`) e certificados X.509 também são suportados.

## 6. Git em pipelines (CI)

- Clone raso (`fetch-depth: 1`) é rápido, mas `git describe`, changelog e versionamento precisam do histórico e das tags — use profundidade total nesses jobs.
- Credenciais do CI: tokens com **escopo mínimo** e de **curta duração**, injetados como segredo da plataforma — nunca no `.gitconfig` ou na URL versionada.
- `safe.directory`: o Git recusa operar num repositório de outro dono (proteção contra CVE-2022-24765); em containers de CI isso aparece — configure apenas o diretório necessário, nunca `*` sem pensar.
- Mantenha o Git **atualizado**: falhas como CVE-2024-32002 (execução de código ao clonar repositório malicioso com submódulos) foram corrigidas em versões novas.

## 7. Mão na massa

| Exemplo | O que demonstra |
|---|---|
| [`01-hooks-do-time.sh`](exemplos/01-hooks-do-time.sh) | hooks versionados com `core.hooksPath`: commit recusado por segredo e por mensagem fora do padrão |
| [`02-assinatura-ssh.sh`](exemplos/02-assinatura-ssh.sh) | gerar chave, assinar e verificar um commit com SSH |
| [`03-segredo-no-historico.sh`](exemplos/03-segredo-no-historico.sh) | provar que apagar não basta e reescrever o histórico |

## 8. Exercícios

[exercicios/README.md](exercicios/) · `./ferramentas/corrigir.sh 11`

## 9. Checklist de segurança do repositório

- [ ] `.gitignore` cobre segredos desde o primeiro commit
- [ ] `.gitattributes` define fim de linha e binários
- [ ] hooks de `pre-commit` e `commit-msg` versionados (`.githooks`)
- [ ] varredura de segredos no CI e *push protection* na plataforma
- [ ] branch principal protegida: PR obrigatório, CI verde, sem force-push
- [ ] commits assinados (pelo menos para quem faz release)
- [ ] tokens com escopo mínimo e validade; nada de credencial em `credential.helper store`
- [ ] Git atualizado nas máquinas e nos runners

## 📚 Fontes oficiais

- Pro Git: [7.4 Assinando seu trabalho](https://git-scm.com/book/pt-br/v2/Ferramentas-do-Git-Assinando-Seu-Trabalho) · [8.2 Atributos do Git](https://git-scm.com/book/pt-br/v2/Customizando-o-Git-Atributos-do-Git) · [8.3 Hooks do Git](https://git-scm.com/book/pt-br/v2/Customizando-o-Git-Hooks-do-Git) · [8.4 Uma política imposta pelo Git](https://git-scm.com/book/pt-br/v2/Customizando-o-Git-Uma-Pol%c3%adtica-de-Exemplo-Imposta-pelo-Git)
- Manual: [githooks](https://git-scm.com/docs/githooks) · [gitattributes](https://git-scm.com/docs/gitattributes) · [git-config (gpg.\*, safe.directory)](https://git-scm.com/docs/git-config) · [git-filter-branch (veja o aviso no topo)](https://git-scm.com/docs/git-filter-branch)
- Ferramentas: [git-filter-repo](https://github.com/newren/git-filter-repo) · [Gitleaks](https://github.com/gitleaks/gitleaks) · [pre-commit](https://pre-commit.com/)
- CVEs citados: [CVE-2022-24765](https://nvd.nist.gov/vuln/detail/CVE-2022-24765) · [CVE-2024-32002](https://nvd.nist.gov/vuln/detail/CVE-2024-32002)

---

⬅️ [Módulo 10](../10-por-dentro-do-git/) · 🏁 Fim da trilha de módulos → [Projetos práticos](../../projetos/)

<sub>© 2026 Prof. Daniel Santos · conteúdo [CC BY-NC-SA 4.0](../../LICENSE-CONTEUDO.md) · código [PolyForm Noncommercial](../../LICENSE)</sub>
