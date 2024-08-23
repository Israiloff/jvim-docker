# Docker Container of [Jvim Java IDE](https://github.com/Israiloff/jvim)

## Overview
This Docker container provides a fully configured [Neovim](https://neovim.io) Java IDE environment, built on a lightweight Alpine Linux base with Python 3. It includes JDK and essential tools for Java development, enhanced with the [Neovim](https://neovim.io) editor for an optimized coding experience.

## Getting Started

1. **Pull the Container**: 
```bash
docker pull israiloff/jvim:latest
```

2. **Run the Container**: 
```bash
docker run -it --network host --name jvim -v /var/run/docker.sock:/var/run/docker.sock -v /usr/local/bin/docker:/usr/local/bin/docker israiloff/jvim
```

> Note: The `-v /var/run/docker.sock:/var/run/docker.sock` option is required for Docker-in-Docker (DinD) functionality.

> Note: The `--network host` option opens the container to the host network, allowing the container to access the host's Docker daemon.

3. **Access Jvim**:  
Once inside the container, use the `nvim` command to start [Neovim](https://neovim.io) and begin coding.

## Features
- [Pre-configured](https://github.com/Israiloff/jvim) [Neovim](https://neovim.io) with Java support.
- Integrated development tools like [Maven](https://maven.apache.org/), [Git](https://git-scm.com/), and others.
- Enhanced coding experience with pre-installed fonts and themes.

## Customization
Users can customize their development environment by modifying the provided [Jvim configurations](https://github.com/Israiloff/jvim) or adding new plugins.

## Support
For support, visit the [project repository](https://github.com/Israiloff/jvim-docker) or [Docker Hub page](https://hub.docker.com/r/israiloff/jvim) for documentation and issue tracking.

