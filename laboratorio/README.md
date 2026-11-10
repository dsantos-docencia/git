# 🧪 Laboratório do Curso de Git

Um ambiente para errar à vontade. Você monta em 20 minutos, usa no curso inteiro e apaga quando quiser — sem risco para seus projetos reais.

| Opção | Para quem | Precisa de |
|---|---|---|
| **A · Git na sua máquina** (recomendado) | todo mundo — é como você vai trabalhar | Git 2.28+ |
| **B · Container** | quem quer um ambiente idêntico ao do professor | Docker |
| **C · Time simulado** | módulos de remotos e conflitos (06 e 05) | A ou B |

---

## Opção A · Git na sua máquina — passo a passo

### 1. Instalar

**Windows**
1. Baixe o instalador em <https://git-scm.com/downloads/win> — ou, no PowerShell: `winget install --id Git.Git -e --source winget`.
2. Nas telas do instalador, as escolhas que importam:
   - **Editor padrão:** escolha um que você saiba usar (VS Code, Notepad++ ou Nano). O padrão é o Vim.
   - **Nome da branch inicial:** marque *Override the default branch name* → `main`.
   - **PATH:** *Git from the command line and also from 3rd-party software* (recomendado).
   - **Fim de linha:** *Checkout Windows-style, commit Unix-style line endings*.
   - **Credential helper:** *Git Credential Manager* (guarda o login das plataformas com segurança).
3. Abra o **Git Bash** (menu Iniciar) — é o terminal usado nos exemplos do curso.

**macOS**
```bash
xcode-select --install     # Git da Apple (um pouco mais antigo)
# ou, mais recente, com Homebrew (https://brew.sh):
brew install git
```

**Linux**
```bash
sudo apt install git        # Debian/Ubuntu
sudo dnf install git        # Fedora/RHEL
```

Confira: `git --version` → qualquer `2.28` ou mais nova.

### 2. Configurar a identidade (uma vez por máquina)

```bash
git config --global user.name  "Seu Nome"
git config --global user.email "seu-email@exemplo.com"   # o mesmo da sua conta GitHub/GitLab/Bitbucket
git config --global init.defaultBranch main
git config --global core.editor "code --wait"            # ou nano, notepad++, vim
git config --global pull.rebase false
```

Windows: `git config --global core.autocrlf true` · Linux/macOS: `git config --global core.autocrlf input`.

Confira tudo: `git config --list --show-origin`.

> 📄 Uma configuração completa e comentada está em [referencia/config-recomendada.md](../referencia/config-recomendada.md).

### 3. Baixar o curso

```bash
cd ~                                     # ou a pasta onde você guarda projetos
git clone https://github.com/dsantos-docencia/git.git curso-git
cd curso-git
bash modulos/00-boas-vindas-e-fundamentos/exemplos/01-ola-git.sh
```

### 4. Criar uma pasta de rascunho

Os exemplos do curso rodam em pastas temporárias. Para os **seus** experimentos, crie um lugar fora do repositório do curso:

```bash
mkdir -p ~/lab-git && cd ~/lab-git
git init -b sandbox
```

Quebrou? `cd ~ && rm -rf ~/lab-git` e recomece. É para isso que ele existe.

### 5. Checklist

- [ ] `git --version` mostra 2.28+
- [ ] `git config user.email` mostra o seu e-mail
- [ ] `git config init.defaultBranch` mostra `main`
- [ ] o exemplo `01-ola-git.sh` rodou até o fim
- [ ] `./ferramentas/corrigir.sh 00 --solucao` mostra “Tudo certo!”

---

## Opção B · Container (Docker)

```bash
./laboratorio/entrar.sh
```

Na primeira vez a imagem é construída (Debian 13 + Git, Git LFS, tig, ShellCheck). Você entra num terminal em `/curso`, com este repositório montado: o que você editar dentro do container aparece na sua máquina e vice-versa. Ao sair (`exit`), o container é descartado.

---

## Opção C · Time simulado (sem internet, sem conta)

Para treinar `push`, `pull`, `fetch` e conflitos **antes** de usar uma plataforma:

```bash
bash laboratorio/criar-time.sh ~/lab-time
```

```text
~/lab-time/
├── servidor.git/   ← repositório "bare": faz o papel do GitHub/GitLab/Bitbucket
├── ana/            ← clone da Ana (user.name/email próprios, nível local)
└── bia/            ← clone da Bia
```

Abra **dois terminais**, um em `ana/` e outro em `bia/`, e trabalhe como se fossem duas pessoas. Roteiro de conflito:

1. Ana: edite a linha 3 do `README.md`, `git commit -am "docs: versão da Ana"`, `git push`.
2. Bia: edite a **mesma** linha, `git commit -am "docs: versão da Bia"`, `git push` → **rejeitado**.
3. Bia: `git pull` → **conflito**. Resolva (Módulo 05), `git add README.md`, `git commit`, `git push`.

Recomeçar: `rm -rf ~/lab-time` e rode o script de novo.

---

## 📚 Fontes oficiais

- [Downloads do Git](https://git-scm.com/downloads) · [Pro Git 1.5 — Instalando o Git](https://git-scm.com/book/pt-br/v2/Primeiros-Passos-Instalando-o-Git) · [1.6 — Configuração inicial](https://git-scm.com/book/pt-br/v2/Primeiros-Passos-Configura%c3%a7%c3%a3o-inicial-do-Git)
- [Git Credential Manager](https://github.com/git-ecosystem/git-credential-manager) · [Docker — instalação](https://docs.docker.com/get-docker/)

<sub>© 2026 Prof. Daniel Santos · conteúdo [CC BY-NC-SA 4.0](../LICENSE-CONTEUDO.md) · código [PolyForm Noncommercial](../LICENSE)</sub>
