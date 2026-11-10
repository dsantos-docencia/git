# 📋 Cheat sheet do Git — comandos, exemplos e variações

Organizado pela **jornada do desenvolvedor**: configurar → criar → registrar → inspecionar → desfazer → ramificar → colaborar → reescrever → publicar → investigar. Cada linha traz o comando, um exemplo real e as variações que mais aparecem no dia a dia.

> Convenções: `<commit>` = hash, branch, tag ou expressão (`HEAD~2`); `[ ]` = opcional. Manual de qualquer comando: `git help <comando>` ou `https://git-scm.com/docs/git-<comando>`.

---

## 1. Configurar

| Comando | Exemplo | Variações |
|---|---|---|
| `git config` | `git config --global user.name "Ana Souza"` | `--local` · `--system` · `--list --show-origin --show-scope` · `--unset` · `--edit` |
| identidade | `git config --global user.email ana@empresa.com` | por pasta: `[includeIf "gitdir:~/trabalho/"]` |
| branch inicial | `git config --global init.defaultBranch main` | |
| editor | `git config --global core.editor "code --wait"` | `nano` · `vim` · `notepad++ -multiInst -nosession` |
| fim de linha | `git config --global core.autocrlf input` | Windows: `true` · melhor: `.gitattributes` |
| alias | `git config --global alias.lg "log --oneline --graph --decorate --all"` | `alias.st status -sb` · `alias.desfaz "reset --soft HEAD~1"` |
| ajuda | `git help log` | `git log -h` (resumo) · `git help -g` (guias) |

## 2. Criar ou obter um repositório

| Comando | Exemplo | Variações |
|---|---|---|
| `git init` | `git init -b main api` | `--bare` (servidor) · `--object-format=sha256` · `--template=<dir>` |
| `git clone` | `git clone https://github.com/org/projeto.git` | `git clone <url> pasta` · `--depth 1` (raso) · `--branch v2.0` · `--recurse-submodules` · `--filter=blob:none` (parcial) · `--mirror` (backup) |

## 3. Registrar mudanças

| Comando | Exemplo | Variações |
|---|---|---|
| `git status` | `git status -sb` | `--porcelain` (scripts) · `--ignored` · `-uall` |
| `git add` | `git add src/app.py` | `.` · `-A` (inclui remoções) · `-u` (só rastreados) · `-p` (por trecho) · `-N` (intenção de adicionar) · `-f` (força ignorado) |
| `git commit` | `git commit -m "feat: login com SSO"` | `-am` (add dos rastreados + commit) · `--amend` · `--amend --no-edit` · `-v` (mostra o diff no editor) · `--allow-empty` · `-S` (assinado) · `--fixup=<commit>` |
| `git rm` | `git rm antigo.py` | `--cached` (para de rastrear) · `-r pasta/` |
| `git mv` | `git mv util.py helpers.py` | |
| `.gitignore` | `echo "*.log" >> .gitignore` | `git check-ignore -v arquivo` · `.git/info/exclude` · `core.excludesFile` |

## 4. Inspecionar

| Comando | Exemplo | Variações |
|---|---|---|
| `git log` | `git log --oneline --graph --all` | `-5` · `--author=Bia` · `--since="2 weeks ago"` · `--grep=frete -i` · `-S"TAXA"` · `-G"regex"` · `-- arquivo` · `--follow` · `-p` · `--stat` · `--format='%h %an %s'` · `A..B` · `--first-parent` · `--no-merges` |
| `git show` | `git show HEAD~1` | `--stat` · `v1.0:config.ini` (arquivo numa versão) · `:arquivo` (versão preparada) |
| `git diff` | `git diff --staged` | (sem args: não preparado) · `HEAD` · `A B` · `A...B` · `--stat` · `--name-only` · `--name-status` · `--word-diff` · `-w` · `-- caminho` |
| `git blame` | `git blame -L 10,30 app.py` | `-w -C -C` (ignora espaço, detecta código movido) · `--ignore-revs-file` |
| `git grep` | `git grep -n "TODO"` | `-i` · `-c` · `-- '*.py'` · `<commit>` (busca numa versão) |
| `git shortlog` | `git shortlog -sn` | `--since` · `-e` (com e-mails) |
| `git reflog` | `git reflog -10` | `show <branch>` · `--date=iso` |
| `git describe` | `git describe --tags` | `--always` · `--abbrev=0` (última tag) |

## 5. Desfazer

| Situação | Comando | Variações / cuidados |
|---|---|---|
| descartar edição não preparada | `git restore app.py` | `.` (tudo) · ⚠️ sem volta |
| tirar da preparação | `git restore --staged app.py` | antigo: `git reset HEAD app.py` |
| arquivo de outra versão | `git restore --source=v1.0 app.py` | `--staged --worktree` |
| corrigir último commit | `git commit --amend` | só se **não** publicado |
| desfazer commits locais | `git reset HEAD~1` | `--soft` (mantém preparado) · `--mixed` (padrão) · `--hard` (descarta) |
| desfazer commit publicado | `git revert <commit>` | `--no-edit` · `-m 1` (merge) · `--no-commit A..B` |
| apagar não rastreados | `git clean -n` → `git clean -fd` | `-x` (inclui ignorados) · `-i` |
| recuperar o “perdido” | `git reflog` → `git branch salva HEAD@{2}` | `git reset --hard HEAD@{1}` |

Tabela completa por situação: [como-desfazer.md](como-desfazer.md).

## 6. Branches e merge

| Comando | Exemplo | Variações |
|---|---|---|
| listar | `git branch -vv` | `-a` (inclui remotas) · `--merged main` · `--no-merged` · `--sort=-committerdate` · `--contains <commit>` |
| criar | `git branch feature/login` | `git branch nome <commit>` |
| trocar | `git switch feature/login` | `-c nova` (cria e troca) · `-` (volta para a anterior) · `--detach <commit>` |
| renomear / apagar | `git branch -m antiga nova` | `-d` (só se mesclada) · `-D` (força) |
| mesclar | `git merge feature/login` | `--no-ff` (sempre cria commit de merge) · `--ff-only` · `--squash` · `--abort` · `-X theirs`/`-X ours` |
| conflitos | `git status` → editar → `git add` → `git commit` | `git mergetool` · `git checkout --ours/--theirs arquivo` · `git config rerere.enabled true` |

## 7. Remotos e colaboração

| Comando | Exemplo | Variações |
|---|---|---|
| `git remote` | `git remote -v` | `add upstream <url>` · `set-url origin <url>` · `rename` · `remove` · `prune origin` |
| `git fetch` | `git fetch origin` | `--all` · `--prune` · `--tags` |
| `git pull` | `git pull` | `--rebase` · `--ff-only` · `origin main` |
| `git push` | `git push -u origin feature/login` | `--tags` · `origin --delete branch` · `--force-with-lease` (nunca `--force` puro) · `--dry-run` |
| rastreamento | `git branch -u origin/main` | `git status -sb` mostra *ahead/behind* |
| credenciais | `git config --global credential.helper manager` | `store` (⚠️ texto puro) · `cache --timeout=3600` · SSH: `ssh-keygen -t ed25519` |

## 8. Reescrever histórico (só o que não foi publicado)

| Comando | Exemplo | Variações |
|---|---|---|
| `git rebase` | `git rebase main` | `-i HEAD~5` (interativo: pick, reword, squash, fixup, drop, edit) · `--autosquash` · `--onto` · `--continue/--skip/--abort` · `--update-refs` |
| `git cherry-pick` | `git cherry-pick a1b2c3d` | `A..B` · `-x` (anota a origem) · `--no-commit` · `--abort` |
| juntar commits | `git reset --soft HEAD~3 && git commit` | `git commit --fixup=<c>` + `git rebase -i --autosquash` |
| limpar segredo do histórico | `git filter-repo --path .env --invert-paths` | ferramenta externa recomendada pelo projeto Git; troque o segredo! |

## 9. Tags e releases

| Comando | Exemplo | Variações |
|---|---|---|
| criar | `git tag -a v1.2.0 -m "Release 1.2.0"` | leve: `git tag v1.2.0` · assinada: `-s` · numa versão antiga: `git tag -a v1.0 <commit>` |
| listar | `git tag -l "v1.*"` | `--sort=-v:refname` · `-n` (com mensagem) |
| publicar | `git push origin v1.2.0` | `--tags` · `--follow-tags` |
| apagar | `git tag -d v1.2.0 && git push origin --delete v1.2.0` | |

## 10. Ferramentas avançadas

| Comando | Exemplo | Variações |
|---|---|---|
| `git stash` | `git stash push -m "meio do login"` | `list` · `pop` · `apply stash@{1}` · `-u` (inclui não rastreados) · `show -p` · `drop` · `branch nova` |
| `git worktree` | `git worktree add ../hotfix hotfix/123` | `list` · `remove` · `prune` |
| `git bisect` | `git bisect start; git bisect bad; git bisect good v1.0` | `run ./teste.sh` (automático) · `reset` |
| `git submodule` | `git submodule add <url> libs/x` | `update --init --recursive` · `foreach` · alternativa: `git subtree` |
| sparse checkout | `git sparse-checkout set apps/web` | `init --cone` · `disable` |
| Git LFS | `git lfs track "*.psd"` | `git lfs ls-files` · `git lfs migrate` |
| `git archive` | `git archive -o v1.zip v1.0` | `--prefix=projeto/` · `--format=tar.gz` |
| `git bundle` | `git bundle create repo.bundle --all` | transporte offline · `git clone repo.bundle` |
| `git maintenance` | `git maintenance start` | `run --task=gc` · antigo: `git gc` |

## 11. Por dentro (encanamento)

| Comando | Exemplo | Para quê |
|---|---|---|
| `git rev-parse` | `git rev-parse --short HEAD` | resolver nomes em hashes · `--show-toplevel` · `--abbrev-ref HEAD` (branch atual) |
| `git rev-list` | `git rev-list --count HEAD` | listar/contar commits em scripts |
| `git cat-file` | `git cat-file -p HEAD` | ver o objeto bruto · `-t` (tipo) · `-s` (tamanho) |
| `git ls-tree` | `git ls-tree -r HEAD --name-only` | conteúdo de uma árvore |
| `git ls-files` | `git ls-files -s` | o índice (área de preparação) |
| `git hash-object` | `echo oi \| git hash-object --stdin` | calcular o id de um conteúdo |
| `git for-each-ref` | `git for-each-ref --format='%(refname:short) %(committerdate:relative)' refs/heads` | relatórios de branches/tags |
| `git count-objects` | `git count-objects -vH` | tamanho do repositório |
| `git fsck` | `git fsck --lost-found` | integridade e objetos órfãos |

## 12. Segurança e automação

| Comando / arquivo | Exemplo | Variações |
|---|---|---|
| hooks | `.git/hooks/pre-commit` | versionados: `git config core.hooksPath .githooks` · framework: pre-commit |
| assinar commits (SSH) | `git config --global gpg.format ssh` + `user.signingkey ~/.ssh/id_ed25519.pub` + `commit.gpgsign true` | GPG: `gpg.format openpgp` · verificar: `git log --show-signature` |
| `.gitattributes` | `* text=auto eol=lf` | `*.png binary` · `*.ps1 text eol=crlf` · `*.zip filter=lfs` |
| varredura de segredos | `gitleaks detect` | `trufflehog git file://.` · proteção na plataforma (push protection) |

---

📚 Referência oficial completa: <https://git-scm.com/docs> · Versão visual do próprio projeto: [git-scm.com/cheat-sheet](https://git-scm.com/cheat-sheet)

<sub>© 2026 Prof. Daniel Santos · conteúdo [CC BY-NC-SA 4.0](../LICENSE-CONTEUDO.md)</sub>
