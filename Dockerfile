FROM codercom/code-server:latest

LABEL maintainer="https://github.com/fxstein"
LABEL decription="VSCode code-server with python and zsh installed"

# First lets update everything
RUN sudo apt-get update

# Update to zsh shell
RUN sudo apt-get install zsh -y
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
USER coder:coder
COPY --chown=coder:coder settings.json /home/coder/.local/share/code-server/User/settings.json

# Install on-my-zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
RUN git clone --branch master --single-branch --depth 1 \
        "git://github.com/zsh-users/zsh-autosuggestions" \
        ~/.oh-my-zsh/plugins/zsh-autosuggestions
RUN echo "source ~/.oh-my-zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" \ 
        >> ~/.zshrc
RUN git clone --branch master --single-branch --depth 1 \
        "git://github.com/zsh-users/zsh-syntax-highlighting.git" \
        ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
RUN sed -i 's/plugins=(.*/plugins=(git vscode ssh-agent)/' ~/.zshrc
RUN echo "# code-server-python startup banner" >> ~/.zshrc
RUN echo "source ~/.startup-banner" >> ~/.zshrc

# Init script for empty volume config structure
COPY tools/init-config.sh /usr/local/bin/init-config
RUN sudo chmod 755 /usr/local/bin/init-config

# Helper tools
COPY --chown=coder:coder tools/startup-banner.zsh /home/coder/.startup-banner
COPY tools/setup-github.zsh /usr/local/bin/setup-github
RUN chmod 755 /usr/local/bin/setup-github

# create config directories and links for persistent use
RUN sudo mkdir -p /config
RUN sudo chown coder:coder /config
RUN mkdir -p /config/.ssh
RUN touch /config/.gitconfig
# these links to the permanent volume 
RUN ln -s /config/.ssh /home/coder/.ssh
RUN ln -s /config/.gitconfig /home/coder/.gitconfig

# place to store all individual projects
RUN sudo mkdir -p /project
RUN sudo chown coder:coder /project
RUN sudo rm -R /home/coder/project
RUN ln -s /project /home/coder/project

WORKDIR /home/coder/project

# This ensures we have a volume mounted even if the user forgot to do bind
# mount. So that they do not lose their data if they delete the container.
VOLUME [ "/project" ]
# Persist configuration
VOLUME [ "/config" ]

# http port. Do not expose to the public internet directly!
EXPOSE 8080

# By default the container will create a unique password on startup and 
# show it in the log output. It is strongly encourgaed to set the ENV
# PASSWORD to your own secure password. Never operate the image without
# a secure PASSWORD
ENV PASSWORD=

ENTRYPOINT ["dumb-init", "--"]
# Make sure we initialize the config if run for the very first time
CMD ["bash", "-c", "init-config && code-server", "--host", "0.0.0.0"]
