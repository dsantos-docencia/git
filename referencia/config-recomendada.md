# ⚙️ Configuração recomendada (`~/.gitconfig`)

Copie, troque nome e e-mail, e remova o que não fizer sentido para você. Cada linha diz **por quê**.

```ini
[user]
    name  = Seu Nome
    email = voce@exemplo.com            # o mesmo e-mail da sua conta na plataforma

[init]
    defaultBranch = main                # padrão das plataformas (e do Git 3.0)

[core]
    editor = code --wait                # ou nano / vim / "notepad++ -multiInst -nosession"
    autocrlf = input                    # Linux/macOS. No Windows: true
    excludesFile = ~/.gitignore_global  # .DS_Store, Thumbs.db, pastas da IDE

[pull]
    rebase = false                      # explícito: pull faz merge (troque para true se o time preferir)

[push]
    autoSetupRemote = true              # primeiro push de uma branch nova já cria o upstream
    followTags = true                   # envia tags anotadas junto com os commits

[fetch]
    prune = true                        # remove referências a branches apagadas no servidor

[merge]
    conflictStyle = zdiff3              # mostra também a versão ORIGINAL no conflito (Git 2.35+)

[rerere]
    enabled = true                      # lembra como você resolveu um conflito e repete

[diff]
    algorithm = histogram               # diffs mais legíveis em código
    colorMoved = default                # destaca blocos que só mudaram de lugar

[rebase]
    autoSquash = true                   # aplica commits --fixup automaticamente
    updateRefs = true                   # atualiza branches empilhadas durante o rebase

[branch]
    sort = -committerdate               # git branch lista as mais recentes primeiro

[help]
    autocorrect = prompt                # "git stauts" → pergunta se você quis dizer status

[alias]
    st   = status -sb
    lg   = log --oneline --graph --decorate --all
    last = log -1 --stat
    desfaz = reset --soft HEAD~1
    amend  = commit --amend --no-edit
    quem   = shortlog -sn --no-merges

# E-mail corporativo automaticamente em tudo que estiver em ~/trabalho/
[includeIf "gitdir:~/trabalho/"]
    path = ~/.gitconfig-trabalho
```

```ini
# ~/.gitconfig-trabalho
[user]
    email = voce@empresa.com.br
```

Conferir: `git config --list --show-origin --show-scope`.

📚 [git-config — todas as chaves](https://git-scm.com/docs/git-config) · [Pro Git 8.1 — Configuração do Git](https://git-scm.com/book/pt-br/v2/Customizando-o-Git-Configura%c3%a7%c3%a3o-do-Git)

<sub>© 2026 Prof. Daniel Santos · CC BY-NC-SA 4.0</sub>
