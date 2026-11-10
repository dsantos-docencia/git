# 🧰 Scripts reais

Ferramentas que eu uso (ou que resolvem problemas que aparecem em todo time) — prontas para usar e, principalmente, para **ler**: cada uma é um resumo prático de vários módulos do curso. Todas têm testes automáticos em [`testes/`](testes/) rodados pelo CI.

> ⚠️ Diferente dos exemplos dos módulos, estes scripts **agem no repositório onde você os executa**. Os que apagam ou reescrevem algo simulam por padrão ou pedem confirmação explícita.

| Script | O que resolve | Uso | Módulos relacionados |
|---|---|---|---|
| [`dia-a-dia/novo-repositorio.sh`](dia-a-dia/novo-repositorio.sh) | começar um projeto já no padrão: `main`, README, `.gitignore` por tipo, `.gitattributes`, `.env.exemplo` | `novo-repositorio.sh api python` | 01, 11 |
| [`dia-a-dia/limpar-branches-mescladas.sh`](dia-a-dia/limpar-branches-mescladas.sh) | apagar branches locais já mescladas (simula por padrão) | `limpar-branches-mescladas.sh --base main --aplicar` | 04 |
| [`dia-a-dia/sincronizar-fork.sh`](dia-a-dia/sincronizar-fork.sh) | atualizar o seu fork com o original (`upstream`), só por avanço rápido | `sincronizar-fork.sh main` | 06 |
| [`auditoria/raio-x-repositorio.sh`](auditoria/raio-x-repositorio.sh) | relatório: tamanho, contribuidores, branches paradas, maiores arquivos do histórico | `raio-x-repositorio.sh ~/projetos/loja --top 10` | 02, 10 |
| [`auditoria/procurar-segredos.sh`](auditoria/procurar-segredos.sh) | encontrar chaves e tokens em **todo** o histórico (inclusive arquivos já apagados) | `procurar-segredos.sh .` | 11 |
| [`release/proxima-versao.sh`](release/proxima-versao.sh) | calcular a próxima versão SemVer pelos Conventional Commits (e criar a tag) | `proxima-versao.sh --tag` | 08 |
| [`release/gerar-changelog.sh`](release/gerar-changelog.sh) | notas de versão em Markdown, agrupadas por tipo | `gerar-changelog.sh v1.2.0 v1.3.0 > NOTAS.md` | 08 |
| [`hooks/commit-msg.sh`](hooks/commit-msg.sh) | recusar mensagens fora do Conventional Commits | via `instalar-hooks.sh` | 01, 11 |
| [`hooks/pre-commit.sh`](hooks/pre-commit.sh) | bloquear `.env`, chaves, tokens e arquivos grandes **antes** do commit | via `instalar-hooks.sh` | 11 |
| [`hooks/instalar-hooks.sh`](hooks/instalar-hooks.sh) | instalar os hooks numa pasta **versionada** (`.githooks` + `core.hooksPath`) | `bash scripts/hooks/instalar-hooks.sh` | 11 |
| [`backup/espelhar-repositorios.sh`](backup/espelhar-repositorios.sh) | backup fiel (`--mirror`) de vários repositórios, incremental | `espelhar-repositorios.sh lista.txt /backup/git` | 06, 10 |

## Exemplos rápidos

```bash
# Antes de assumir um projeto legado
bash scripts/auditoria/raio-x-repositorio.sh ~/projetos/erp-antigo --top 10
bash scripts/auditoria/procurar-segredos.sh ~/projetos/erp-antigo

# Fechando uma versão
git switch main && git pull
bash scripts/release/proxima-versao.sh            # mostra: v1.4.0
bash scripts/release/gerar-changelog.sh > NOTAS.md
bash scripts/release/proxima-versao.sh --tag && git push --follow-tags

# Backup agendado (cron, todo dia às 2h)
# 0 2 * * * /opt/curso-git/scripts/backup/espelhar-repositorios.sh /etc/git-backup.txt /srv/backup/git
```

No Windows, rode pelo **Git Bash**.

## Contribua com o seu

Tem um script de Git que salva o seu dia? Envie pela trilha [📜 Enviar um script](https://github.com/dsantos-docencia/git/issues/new/choose). Os aprovados entram em [`comunidade/`](comunidade/) com o seu crédito.

<sub>© 2026 Prof. Daniel Santos · código [PolyForm Noncommercial](../LICENSE) · texto [CC BY-NC-SA 4.0](../LICENSE-CONTEUDO.md)</sub>
