# Laboratório do Curso de Git — ambiente isolado e reproduzível
# Prof. Daniel Santos · github.com/dsantos-docencia/git · © 2026 (PolyForm-NC)
FROM debian:13-slim

ENV DEBIAN_FRONTEND=noninteractive LANG=C.UTF-8

# git      — o protagonista        git-lfs — arquivos grandes (Módulo 09)
# tig      — histórico no terminal  shellcheck — o CI do curso usa
# openssh-client — remotos por SSH (Módulo 06)
RUN apt-get update && apt-get install -y --no-install-recommends \
        git git-lfs tig \
        bash coreutils findutils grep sed gawk procps \
        less nano vim-tiny \
        shellcheck \
        openssh-client curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Usuário sem privilégios e configuração inicial razoável para estudar.
RUN useradd -m -s /bin/bash aluno
USER aluno
RUN git config --global init.defaultBranch main \
 && git config --global user.name  "Aluno do Laboratório" \
 && git config --global user.email "aluno@laboratorio.local" \
 && git config --global core.editor nano \
 && git config --global pull.rebase false \
 && git config --global safe.directory /curso
WORKDIR /curso
CMD ["bash"]
