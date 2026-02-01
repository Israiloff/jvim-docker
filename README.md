# Docker Container of [Jvim Java IDE](https://github.com/Israiloff/jvim)

## Overview
This Docker image provides a fully configured **Neovim-based Java IDE** built on **Ubuntu Linux**.
It is designed for **reproducible, multi-architecture development** (arm64 / amd64) and ships with a
modern Java toolchain, rich terminal environment, and a preconfigured **Jvim** setup.

The image is built using **Docker Buildx** and published as a **multi-arch image**, so the same tag
works seamlessly on Apple Silicon (M1/M2) and x86_64 machines.

---

## Table of Contents
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Components](#components)
- [Features](#features)
- [Usage Examples](#usage-examples)
- [Build Instructions](#build-instructions)
- [Multi-Architecture Build](#multi-architecture-build)
- [Customization](#customization)
- [Troubleshooting](#troubleshooting)
- [Support](#support)

---

## Prerequisites
- Docker (with Buildx enabled)
- Docker Desktop (macOS / Windows) or Docker Engine (Linux)
- Optional: Docker Hub account (for pushing images)

---

## Getting Started

### Quick Start

Pull the latest multi-arch image:

```bash
docker pull israiloff/jvim:latest
````

Run the container:

```bash
docker run -it \
  --name jvim \
  -v $(pwd):/root/project \
  israiloff/jvim
```

Inside the container:

```bash
nvim
```

---

### Running with Docker socket (Docker-from-Docker)

To allow Docker CLI usage inside the container (recommended approach):

```bash
docker run -it \
  --name jvim \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $(pwd):/root/project \
  israiloff/jvim
```

> ℹ️ This image **does not run Docker daemon inside** the container.
> Instead, it uses the host Docker daemon via socket mounting (best practice).

---

## Components

### Base System

* **Ubuntu 24.04 LTS**
* **glibc-based system** (required for upstream Neovim binaries)
* **Timezone support** (default: `Asia/Tashkent`)
* **Bash & ZSH**

### Java Development

* **OpenJDK** (default: JDK 21)
* **Maven**
* **Git**

  * Custom alias: `git pushall`

### Build & Native Tooling

* **GCC / G++**
* **Make**
* **Build-essential**
* **Cargo (Rust toolchain)**

### CLI Utilities

* **curl**
* **ripgrep**
* **fd**
* **fzf**
* **zip / unzip**

### Node.js Ecosystem

* **Node.js**
* **npm**
* **Yarn**

### Neovim IDE

* **Neovim (latest release from GitHub)**

  * Installed per-architecture during build (`arm64` / `amd64`)
* **Jvim configuration**

  * LSP (Java, XML, YAML, etc.)
  * Treesitter
  * Lazy.nvim plugin manager
  * Markdown preview

### Shell Environment

* **ZSH (default shell)**
* **Oh My Zsh**
* **Theme**: `half-life`
* **Plugins**:

  * zsh-autosuggestions
  * zsh-syntax-highlighting
  * fast-syntax-highlighting
  * zsh-autocomplete

---

## Features

### Development

* ✅ Full Java IDE inside terminal
* ✅ Latest Neovim from official GitHub releases
* ✅ Java / C++ / Rust / Node.js support
* ✅ Maven-based Java workflows
* ✅ Docker CLI access via socket

### Platform Support

* ✅ linux/arm64 (Apple Silicon)
* ✅ linux/amd64 (Intel / AMD)
* ✅ Single tag, multi-arch manifest

### UX

* ✅ ZSH + Oh My Zsh
* ✅ Fast startup
* ✅ Headless plugin sync during build
* ✅ Clean, reproducible environment

---

## Usage Examples

### New Java Project

```bash
docker run -it -v $(pwd):/root/project israiloff/jvim
```

Inside container:

```bash
mvn archetype:generate \
  -DgroupId=com.example \
  -DartifactId=my-app \
  -DarchetypeArtifactId=maven-archetype-quickstart \
  -DinteractiveMode=false

cd my-app
nvim
```

---

### Existing Project

```bash
docker run -it \
  -v /path/to/project:/root/project \
  israiloff/jvim
```

---

## Build Instructions

### Local build (single architecture)

```bash
docker build \
  --build-arg JDK_VERSION=21 \
  --build-arg TIMEZONE=Asia/Tashkent \
  -t israiloff/jvim:local .
```

---

## Multi-Architecture Build

This project uses **Docker Buildx** and **BuildKit platform awareness**.

### One-command multi-arch build & push

```bash
docker buildx build \
  --platform linux/arm64,linux/amd64 \
  --build-arg JDK_VERSION=21 \
  --build-arg TIMEZONE=Asia/Tashkent \
  -t israiloff/jvim:0.4.14 \
  -t israiloff/jvim:latest \
  --push \
  .
```

### Verify manifest

```bash
docker buildx imagetools inspect israiloff/jvim:latest
```

---

## Customization

### Neovim

Mount your config:

```bash
docker run -it \
  -v ~/.config/nvim:/root/.config/nvim \
  israiloff/jvim
```

### ZSH

Edit `.zshrc` inside container or mount it:

```bash
-v ~/.zshrc:/root/.zshrc
```

---

## Troubleshooting

### Neovim plugins

```bash
nvim --headless "+Lazy! sync" +qa
```

### Markdown preview

```bash
cd ~/.local/share/nvim/lazy/markdown-preview.nvim
yarn install
```

### Docker not working

Ensure socket is mounted:

```bash
-v /var/run/docker.sock:/var/run/docker.sock
```

---

## Support

For support, visit the [project repository](https://github.com/Israiloff/jvim-docker) or [Docker Hub page](https://hub.docker.com/r/israiloff/jvim) for documentation and issue tracking.

### Related Projects

- [Jvim Configuration](https://github.com/Israiloff/jvim) - The Neovim configuration used in this container
- [Neovim](https://neovim.io) - Hyperextensible Vim-based text editor

---

**License**: This project follows the same license as the Jvim configuration.
**Maintained by**: [Israiloff](https://github.com/Israiloff)

