ARG PYTHON_VERSION

FROM python:${PYTHON_VERSION}-alpine

ARG JDK_VERSION
ARG TIMEZONE

RUN apk add --no-cache tzdata
ENV TZ=${TIMEZONE}

#PREPARING OS
RUN apk add --no-cache bash
RUN apk update --no-cache
RUN apk upgrade --no-cache


#CHANGING DEFAULT SHELL
SHELL ["/bin/bash", "-c"]

#INSTALLING COMMONS
RUN apk add --no-cache --no-interactive zip
RUN apk add --no-cache --no-interactive unzip
RUN apk add --no-cache --no-interactive curl
RUN apk add --no-cache --no-interactive openjdk${JDK_VERSION}
RUN apk add --no-cache --no-interactive maven
RUN apk add --no-cache --no-interactive git
RUN apk add --no-cache --no-interactive npm
RUN apk add --no-cache --no-interactive yarn
RUN apk add --no-cache --no-interactive neovim
RUN apk add --no-cache --no-interactive zsh
RUN apk add --no-cache --no-interactive g++

#CHANGING DEFAULT SHELL TO ZSH
SHELL ["/bin/zsh", "-c"]

#INSTALLING AND CONFIGURING OH MY ZSH
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
RUN sed -i -e 's/ZSH_THEME="robbyrussell"/ZSH_THEME="half-life"/g' ~/.zshrc
RUN apk add --no-cache --no-interactive zsh-vcs
RUN echo "export SHELL=/bin/zsh" >> $HOME/.zshrc

#GIT CONFIGS
RUN git config --global alias.pushall '!f() { for remote in $(git remote); do git push "$remote" "$@"; done; }; f'

#INSTALLING DOCKER
RUN apk add --update docker openrc
RUN rc-update add docker boot
RUN apk add --no-cache docker

#INSTALLING JVIM
RUN mkdir -p ~/.config/nvim
RUN git clone https://github.com/Israiloff/jvim.git ~/.config/nvim

ENTRYPOINT ["/bin/zsh"]
