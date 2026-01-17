# Docker Container of [Jvim Java IDE](https://github.com/Israiloff/jvim)

## Overview
This Docker container provides a fully configured [Neovim](https://neovim.io)-based Java IDE environment, built on a lightweight Alpine Linux base with Python 3. It includes a comprehensive development toolchain with JDK, build tools, and an enhanced terminal experience, making it a complete solution for Java development in an isolated, reproducible environment.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Components](#components)
- [Features](#features)
- [Usage Examples](#usage-examples)
- [Build Instructions](#build-instructions)
- [Customization](#customization)
- [Troubleshooting](#troubleshooting)
- [Support](#support)

## Prerequisites
- Docker installed on your host system
- Basic understanding of Docker commands
- For Docker-in-Docker (DinD) functionality: Docker socket access on the host

## Getting Started

### Quick Start

1. **Pull the Container**: 
```bash
docker pull israiloff/jvim:latest
```

2. **Run the Container**: 
```bash
docker run -it --network host --name jvim -v /var/run/docker.sock:/var/run/docker.sock -v /usr/local/bin/docker:/usr/local/bin/docker israiloff/jvim
```

> **Note**: The `-v /var/run/docker.sock:/var/run/docker.sock` option is required for Docker-in-Docker (DinD) functionality, allowing you to run Docker commands inside the container.

> **Note**: The `--network host` option opens the container to the host network, allowing the container to access the host's Docker daemon and network services.

3. **Access Jvim**:  
Once inside the container, use the `nvim` command to start [Neovim](https://neovim.io) and begin coding.

### Running with Volume Mounts

To persist your projects and configurations, mount your local directories:

```bash
docker run -it --network host --name jvim \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /usr/local/bin/docker:/usr/local/bin/docker \
  -v $(pwd)/projects:/root/projects \
  israiloff/jvim
```

## Components

This Docker image includes a comprehensive set of tools and configurations optimized for Java development:

### Base System
- **Alpine Linux**: Lightweight, security-oriented Linux distribution
- **Python 3**: Latest Python 3.x runtime from Alpine repositories
- **Timezone Support**: Configurable timezone (default: Asia/Tashkent)
- **Bash & ZSH**: Multiple shell options for flexibility

### Java Development Tools
- **OpenJDK**: Java Development Kit (configurable version, default: JDK 21)
- **Maven**: Build automation and dependency management tool for Java projects
- **Git**: Version control system with custom aliases for enhanced productivity
  - Custom `pushall` alias to push to all remotes simultaneously

### Build and Compilation Tools
- **GCC/G++**: GNU Compiler Collection for C/C++ compilation
- **Make**: Build automation tool
- **Cargo**: Rust package manager and build system
- **build-base**: Essential build tools and libraries
- **libc6-compat**: Compatibility layer for glibc-based applications

### JavaScript/Node.js Ecosystem
- **npm**: Node.js package manager
- **Yarn**: Fast, reliable, and secure dependency management

### Archive and Utility Tools
- **zip/unzip**: Compression and decompression utilities
- **curl**: Command-line tool for transferring data with URLs

### Neovim IDE
- **Neovim**: Latest stable release (x86_64 architecture)
- **[Jvim Configuration](https://github.com/Israiloff/jvim)**: Pre-configured Neovim setup optimized for Java development
  - LSP (Language Server Protocol) support for intelligent code completion
  - Syntax highlighting and code formatting
  - Plugin management via Lazy.nvim
  - Markdown preview with live rendering

### Enhanced Shell Environment
- **ZSH**: Z Shell as the default shell
- **Oh My ZSH**: Framework for managing ZSH configuration
- **ZSH Theme**: "half-life" theme for a modern prompt experience
- **ZSH Plugins**:
  - `zsh-autosuggestions`: Fish-like autosuggestions for ZSH
  - `zsh-syntax-highlighting`: Fish-like syntax highlighting for ZSH
  - `fast-syntax-highlighting`: Feature-rich syntax highlighting for ZSH
  - `zsh-autocomplete`: Real-time type-ahead completion for ZSH

### Docker-in-Docker (DinD)
- **Docker**: Docker Engine installed inside the container
- **OpenRC**: Init system for managing Docker service
- Enables running Docker commands and containers within the development environment

## Features

### Development Capabilities
- ✅ Complete Java development environment with JDK 21
- ✅ Pre-configured [Neovim](https://neovim.io) with [Jvim](https://github.com/Israiloff/jvim) for Java-optimized IDE experience
- ✅ Maven for dependency management and build automation
- ✅ Git integration with enhanced aliases
- ✅ Multi-language build support (Java, C/C++, Rust)
- ✅ Docker-in-Docker for containerized workflows
- ✅ Node.js/npm/Yarn for JavaScript development

### User Experience
- ✅ Enhanced terminal with ZSH and Oh My ZSH
- ✅ Intelligent command suggestions and completions
- ✅ Syntax highlighting in the terminal
- ✅ Modern and informative prompt theme
- ✅ Persistent shell history and configurations

### Performance & Efficiency
- ✅ Lightweight Alpine Linux base (~200MB base image)
- ✅ Fast startup time
- ✅ Optimized layer caching for quick rebuilds
- ✅ Latest Neovim release with async operations

## Usage Examples

### Starting a New Java Project

```bash
# Run the container
docker run -it --name jvim -v $(pwd):/root/project israiloff/jvim

# Inside the container, create a new Maven project
mvn archetype:generate -DgroupId=com.example -DartifactId=my-app -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false

# Navigate to the project and open with Neovim
cd my-app
nvim
```

### Working with Existing Projects

```bash
# Mount your existing project directory
docker run -it --name jvim -v /path/to/your/project:/root/project israiloff/jvim

# Inside the container
cd /root/project
nvim
```

### Using Docker Inside the Container

```bash
# Run with Docker socket mounted
docker run -it --name jvim \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /usr/local/bin/docker:/usr/local/bin/docker \
  israiloff/jvim

# Inside the container, use Docker commands
docker ps
docker build -t myapp .
```

## Build Instructions

To build the image locally with custom parameters:

```bash
# Using the provided build script
./cmd.sh

# Or manually with custom arguments
docker build \
  --build-arg JDK_VERSION=21 \
  --build-arg PYTHON_VERSION=3 \
  --build-arg TIMEZONE=Asia/Tashkent \
  -t israiloff/jvim:latest .
```

### Build Arguments

- `JDK_VERSION`: Java Development Kit version (default: 21, other options: 11, 17, 21)
- `PYTHON_VERSION`: Python version (default: 3, other options: 3.9, 3.10, 3.11, 3.12)
- `TIMEZONE`: Container timezone (default: Asia/Tashkent, any valid timezone from [IANA Time Zone Database](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones))

## Customization

### Neovim Configuration
The Jvim configuration can be customized by modifying files in `~/.config/nvim` inside the container. To persist these changes:

```bash
docker run -it --name jvim \
  -v ~/.config/nvim:/root/.config/nvim \
  israiloff/jvim
```

For more details on Jvim customization, visit the [Jvim repository](https://github.com/Israiloff/jvim).

### ZSH Configuration
Customize your shell experience by editing `~/.zshrc`:

```bash
# Inside the container
nvim ~/.zshrc
```

To persist ZSH configurations:

```bash
docker run -it --name jvim \
  -v ~/.zshrc:/root/.zshrc \
  israiloff/jvim
```

### Adding Additional Plugins
You can install additional Neovim plugins or ZSH plugins by modifying the respective configuration files and restarting the editor or shell.

## Troubleshooting

### Neovim Not Starting
If Neovim fails to start or shows errors:
```bash
# Synchronize plugins
nvim --headless "+Lazy! sync" +qa
```

### Markdown Preview Not Working
If Markdown preview fails:
```bash
cd ~/.local/share/nvim/lazy/markdown-preview.nvim
yarn install
```

### Docker Commands Not Working Inside Container
Ensure Docker socket is properly mounted:
```bash
docker run -it --name jvim \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /usr/local/bin/docker:/usr/local/bin/docker \
  israiloff/jvim
```

### Permission Issues
If you encounter permission issues with mounted volumes, you may need to adjust permissions on the host:
```bash
chmod -R 755 /path/to/your/project
```

## Support
For support, visit the [project repository](https://github.com/Israiloff/jvim-docker) or [Docker Hub page](https://hub.docker.com/r/israiloff/jvim) for documentation and issue tracking.

### Related Projects
- [Jvim Configuration](https://github.com/Israiloff/jvim) - The Neovim configuration used in this container
- [Neovim](https://neovim.io) - Hyperextensible Vim-based text editor

---

**License**: This project follows the same license as the Jvim configuration.

**Maintained by**: [Israiloff](https://github.com/Israiloff)

