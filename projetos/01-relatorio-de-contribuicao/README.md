# Projeto 01 · Relatório de contribuição

**Problema:** a coordenação quer, todo mês, um resumo de quem trabalhou em quê no repositório — sem instalar nada.

**Entrega:** `relatorio.sh [repo] [--desde AAAA-MM-DD] [--ate AAAA-MM-DD]` que imprime uma tabela Markdown por autor: commits, linhas adicionadas, linhas removidas e arquivos distintos tocados — ignorando merges, ordenada por commits.

```console
$ bash projetos/01-relatorio-de-contribuicao/relatorio.sh ~/projetos/loja --desde 2026-10-01
| Autor | Commits | + linhas | − linhas | Arquivos |
|---|---:|---:|---:|---:|
| Ana Souza | 42 | 1830 | 611 | 37 |
| Bia Lima | 17 | 402 | 95 | 12 |
```

**Conceitos usados:** `git log --numstat` e `--format` (Módulo 02), `--since/--until`, `%aN` (nome com `.mailmap` aplicado), formatos estáveis para scripts (Módulo 10).

**Desafios extras:** respeitar um `.mailmap` para unificar e-mails da mesma pessoa; adicionar uma coluna com a data do último commit; aceitar `--formato csv`.

> ⚠️ Linhas de código não medem produtividade. Use o relatório para entender **onde** o time está trabalhando, nunca para ranquear pessoas.

> 🧠 `--since`/`--until` filtram pela data do **commit** (committer), não do autor — num commit rebaseado as duas diferem.

Testes: `testes/relatorio.teste.sh`, rodados pela etapa 5 de `./ferramentas/verificar-tudo.sh`.

<sub>© 2026 Prof. Daniel Santos · CC BY-NC-SA 4.0</sub>
