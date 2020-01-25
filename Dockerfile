FROM codercom/code-server:latest

MAINTAINER https://github.com/fxstein

# First lets update everything
RUN sudo apt-get update

# Update to zsh shell
RUN sudo apt-get install zsh -y

# Install on-my-zsh
RUN sudo git clone --branch master --single-branch --depth 1 \
        "git://github.com/robbyrussell/oh-my-zsh.git" ~/.oh-my-zsh
RUN sudo git clone --branch master --single-branch --depth 1 \
        "git://github.com/zsh-users/zsh-autosuggestions" \
        ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
RUN sudo git clone --branch master --single-branch --depth 1 \
        "git://github.com/zsh-users/zsh-syntax-highlighting.git" \
        ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
RUN sudo sed -i -e "s#bin/bash#bin/zsh#" /etc/passwd

# Setup python development
RUN sudo apt-get install python3.7 python3-pip inetutils-ping python3-venv -y
RUN python3.7 -m pip install pip
RUN python3.7 -m pip install wheel
RUN python3.7 -m pip install flake8

# Install extensions
RUN code-server --install-extension ms-python.python
RUN code-server --install-extension eamodio.gitlens

# code-server settings
USER coder
COPY settings.json /home/coder/.local/share/code-server/User/settings.json

WORKDIR /home/coder/project

# This ensures we have a volume mounted even if the user forgot to do bind
# mount. So that they do not lose their data if they delete the container.
# Coder home to also persist git config and ssh keys.
VOLUME [ "/home/coder" ]

# http port. Do not expose to the public internet directly!
EXPOSE 8080

# By default the container will create a unique password on startup and 
# show it in the log output. It is strongly encourgaed to set the ENV
# PASSWORD to your own secure password. Never operate the image without
# a secure PASSWORD
ENV PASSWORD=

ENTRYPOINT ["dumb-init", "code-server", "--host", "0.0.0.0"]