# 🚀 Projetos práticos

Projetos que juntam vários módulos num problema real. Cada um tem enunciado, uma solução comentada e testes automáticos (rodados pela etapa 5 de `./ferramentas/verificar-tudo.sh`). Tente fazer a sua versão **antes** de ler a solução.

| # | Projeto | Problema | Módulos |
|---|---|---|---|
| 01 | [Relatório de contribuição](01-relatorio-de-contribuicao/) | quem trabalhou em quê, em Markdown, por período | 02, 10 |
| 02 | [Guardião de push](02-guardiao-de-push/) | hook `pre-push` contra push na `main` e force push | 06, 07, 10, 11 |
| 03 | [Release de ponta a ponta](03-release-de-ponta-a-ponta/) | da verificação à tag publicada, num comando | 06, 08 |

Rodar os testes de um projeto:

```bash
( source ferramentas/lib/teste.sh; rodar_testes projetos/02-guardiao-de-push/testes/guardiao.teste.sh projetos/02-guardiao-de-push/guardiao.sh )
```

<sub>© 2026 Prof. Daniel Santos · CC BY-NC-SA 4.0</sub>
