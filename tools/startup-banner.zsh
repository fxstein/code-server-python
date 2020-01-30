#!/usr/bin/env zsh

# code-server-python info
# Basic version info
CODE_SERVER_VERSION=`code-server --version | sed -n 1p | cut -d" " -f3`
PYTHON3_VERSION=`python3 --version | cut -d" " -f2`
PYTHON3_7_VERSION=`python3.7 --version | cut -d" " -f2`
GIT_VERSION=`git --version | cut -d" " -f3`
ZSH_VERSION=`zsh --version | cut -d" " -f2`

export VERSIONS='code-server '$CODE_SERVER_VERSION' | python3 '$PYTHON3_VERSION' | python3.7 '$PYTHON3_7_VERSION' | git '$GIT_VERSION' | zsh '$ZSH_VERSION

# Display header
setterm -linewrap off
echo $fg[red]'                 .___                                                                          __  .__                   '
echo $fg[red]'  ____  ____   __| _/____          ______ ______________  __ ___________       ______ ___.__._/  |_|  |__   ____   ____  '
echo $fg[white]'_/ ___\/  _ \ / __ |/ __ \   ___  /  ___// __ \_  __ \  \/ // __ \_  __ \  ___ \____ <   |  |\   __\  |  \ /  _ \ /    \ '
echo $fg[white]'\  \__(  <_> ) /_/ \  ___/  /__/  \___ \\\  ___/|  | \/\   /\  ___/|  | \/ /__/ |  |_> >___  | |  | |   Y  (  <_> )   |  \'
echo $fg[red]' \___  >____/\____ |\___  >      /____  >\___  >__|    \_/  \___  >__|         |   __// ____| |__| |___|  /\____/|___|  /'
echo $fg[red]'     \/           \/    \/            \/     \/                 \/             |__|   \/                \/            \/ '
echo $fg[blue]'https://github.com/fxstein/code-server-python                         https://hub.docker.com/r/fxstein/code-server-python'
echo $fg[green]$VERSIONS  
setterm -linewrap on
echo 
# Current directory and content to start with..
echo $fg[magenta]`pwd`
ls -l | sed 1d