ARG OS_VERSION=22.04

FROM ubuntu:${OS_VERSION}

ARG TIMEZONE
ARG JDK_VERSION
ARG ARCH

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=${TIMEZONE}

SHELL ["/bin/bash", "-c"]

# -------------------------
# Base / timezone
# -------------------------
RUN apt-get update
RUN apt-get install -y --no-install-recommends tzdata
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime
RUN echo ${TZ} > /etc/timezone

# -------------------------
# Base utilities (each отдельно)
# -------------------------
RUN apt-get update
RUN apt-get install -y --no-install-recommends ca-certificates
RUN apt-get install -y --no-install-recommends curl
RUN apt-get install -y --no-install-recommends git
RUN apt-get install -y --no-install-recommends bash
RUN apt-get install -y --no-install-recommends zsh
RUN apt-get install -y --no-install-recommends zip
RUN apt-get install -y --no-install-recommends unzip
RUN apt-get install -y --no-install-recommends gnupg

# -------------------------
# Python (Ubuntu python3)
# -------------------------
RUN apt-get update
RUN apt-get install -y --no-install-recommends python3
RUN apt-get install -y --no-install-recommends python3-pip
RUN apt-get install -y --no-install-recommends python3-venv

# -------------------------
# JDK + Maven
# -------------------------
RUN apt-get update
RUN apt-get install -y --no-install-recommends openjdk-${JDK_VERSION}-jdk
RUN apt-get install -y --no-install-recommends maven

# -------------------------
# Build tools / cargo
# -------------------------
RUN apt-get update
RUN apt-get install -y --no-install-recommends build-essential
RUN apt-get install -y --no-install-recommends gcc
RUN apt-get install -y --no-install-recommends g++
RUN apt-get install -y --no-install-recommends make
RUN apt-get install -y --no-install-recommends cargo

# -------------------------
# CLI tools
# -------------------------
RUN apt-get update
RUN apt-get install -y --no-install-recommends ripgrep
RUN apt-get install -y --no-install-recommends fd-find
RUN apt-get install -y --no-install-recommends fzf

# fd in Ubuntu is fdfind -> make fd available
RUN ln -sf /usr/bin/fdfind /usr/local/bin/fd

# -------------------------
# Node + npm + yarn
# -------------------------
RUN apt-get update
RUN apt-get install -y --no-install-recommends nodejs
RUN apt-get install -y --no-install-recommends npm
RUN npm install -g yarn

# -------------------------
# Docker CLI (daemon НЕ запускаем внутри build)
# -------------------------
RUN apt-get update
RUN apt-get install -y --no-install-recommends docker.io

# -------------------------
# Install Neovim (latest) from GitHub releases
# -------------------------
RUN rm -rf /opt/nvim
RUN mkdir -p /opt

# Download archive depending on ARCH
# BuildKit automatically provides these
ARG TARGETARCH

RUN echo "Building for TARGETARCH=${TARGETARCH}"

RUN if [ "${TARGETARCH}" = "arm64" ]; then \
    echo "Downloading Neovim latest for arm64"; \
    curl -fL -o /tmp/nvim.tar.gz \
    https://github.com/neovim/neovim/releases/latest/download/nvim-linux-arm64.tar.gz; \
    elif [ "${TARGETARCH}" = "amd64" ]; then \
    echo "Downloading Neovim latest for amd64"; \
    curl -fL -o /tmp/nvim.tar.gz \
    https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz; \
    else \
    echo "Unsupported TARGETARCH=${TARGETARCH}"; \
    exit 1; \
    fi

RUN tar -xzf /tmp/nvim.tar.gz -C /opt
RUN rm -f /tmp/nvim.tar.gz

# Create stable path /opt/nvim -> extracted dir
RUN if [ -d /opt/nvim-linux-arm64 ]; then ln -s /opt/nvim-linux-arm64 /opt/nvim; fi
RUN if [ -d /opt/nvim-linux-x86_64 ]; then ln -s /opt/nvim-linux-x86_64 /opt/nvim; fi

RUN ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
RUN nvim --version

# -------------------------
# Oh My Zsh (non-interactive)
# -------------------------
SHELL ["/bin/zsh", "-c"]

RUN export RUNZSH=no
RUN export CHSH=no
RUN export KEEP_ZSHRC=yes
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

RUN sed -i -e 's/ZSH_THEME="robbyrussell"/ZSH_THEME="half-life"/g' ~/.zshrc
RUN echo "export SHELL=/bin/zsh" >> ~/.zshrc

# -------------------------
# Git config
# -------------------------
RUN git config --global alias.pushall '!f() { for remote in $(git remote); do git push "$remote" "$@"; done; }; f'

# -------------------------
# Install JVIM
# -------------------------
RUN mkdir -p ~/.config/nvim
RUN rm -rf ~/.config/nvim
RUN git clone --depth 1 --branch master https://github.com/Israiloff/jvim.git ~/.config/nvim

# Lazy sync (headless)
RUN nvim --headless "+Lazy! sync" +qa

# markdown-preview.nvim deps
RUN cd $HOME/.local/share/nvim/lazy/markdown-preview.nvim
RUN yarn install

# -------------------------
# Zsh plugins
# -------------------------
RUN git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
RUN git clone --depth 1 https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
RUN git clone --depth 1 https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autocomplete

RUN sed -i -e 's/^plugins=([^)]*)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)/g' ~/.zshrc

ENTRYPOINT ["/bin/zsh"]
