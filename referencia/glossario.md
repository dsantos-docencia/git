# 📖 Glossário

| Termo (PT) | Original | O que é |
|---|---|---|
| Repositório | repository | a pasta `.git`: todos os commits, branches e tags de um projeto |
| Repositório *bare* | bare repository | só o `.git`, sem arquivos de trabalho — o formato usado em servidores |
| Diretório de trabalho | working tree | os arquivos que você edita |
| Área de preparação | staging area, index | o que vai entrar no próximo commit |
| Commit | commit | uma foto completa do projeto + autor, data, mensagem e pai(s) |
| Hash / SHA | object id | identificador do objeto (40 hex no SHA-1; 64 no SHA-256) |
| Branch | branch | ponteiro móvel para um commit; avança a cada commit |
| HEAD | HEAD | aponta para a branch (ou commit) em que você está |
| HEAD destacado | detached HEAD | HEAD apontando direto para um commit, sem branch |
| Tag | tag | ponteiro fixo, normalmente para uma versão (`v1.2.0`); anotada = com autor e mensagem |
| Remoto | remote | outro repositório com quem você troca commits (`origin`, `upstream`) |
| Branch de rastreamento remoto | remote-tracking branch | `origin/main`: a última posição conhecida da `main` no remoto |
| Upstream | upstream | a branch remota que a sua branch local acompanha |
| Merge (mesclagem) | merge | junta duas linhas de desenvolvimento |
| Avanço rápido | fast-forward | merge sem commit novo: a branch só “anda para a frente” |
| Conflito | conflict | o mesmo trecho mudou dos dois lados; você decide o resultado |
| Rebase | rebase | reaplica commits sobre outra base, criando commits novos |
| Cherry-pick | cherry-pick | copia um commit específico para a branch atual |
| Stash | stash | gaveta temporária para mudanças não commitadas |
| Reflog | reflog | diário local de por onde o HEAD e as branches passaram |
| Pull / Merge Request | pull request (GitHub/Bitbucket), merge request (GitLab) | pedido de revisão para mesclar uma branch na plataforma |
| Fork | fork | cópia de um repositório na plataforma, sob a sua conta |
| Porcelana / encanamento | porcelain / plumbing | comandos para pessoas / comandos estáveis para scripts |
| Hook | hook | script executado automaticamente em eventos (antes do commit, antes do push…) |
| Submódulo | submodule | um repositório dentro de outro, fixado num commit |
| Worktree | worktree | um segundo diretório de trabalho ligado ao mesmo repositório |
| Packfile | packfile | arquivo compactado que guarda muitos objetos com deltas |
| Reftable | reftable | formato novo de armazenamento de referências (padrão previsto no Git 3.0) |

Glossário oficial (em inglês): [gitglossary](https://git-scm.com/docs/gitglossary).

<sub>© 2026 Prof. Daniel Santos · CC BY-NC-SA 4.0</sub>
