FROM codercom/code-server:latest

MAINTAINER https://github.com/fxstein

# First lets update everything
RUN sudo apt-get update

# Update to zsh shell
RUN sudo apt-get install zsh -y

# Setup python development
RUN sudo apt-get install python3.7 python3-pip inetutils-ping -y
RUN python3.7 -m pip install pip
RUN python3.7 -m pip install wheel

# Install extensions
RUN code-server --install-extension ms-python.python
RUN code-server --install-extension eamodio.gitlens

# Copy Python requirements file
COPY requirements.txt /tmp/requirements.txt

# code-server settings
USER coder
COPY settings.json /home/coder/.local/share/code-server/User/settings.json

WORKDIR /home/coder/project

# This ensures we have a volume mounted even if the user forgot to do bind
# mount. So that they do not lose their data if they delete the container.
# Coder home to also persist git config and ssh keys.
VOLUME [ "/home/coder" ]
VOLUME [ "/home/coder/project" ]

# http port. Do not expose to the public internet directly!
EXPOSE 8080

ENTRYPOINT ["dumb-init", "code-server", "--host", "0.0.0.0"]