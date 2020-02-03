#!/bin/bash

echo "info  Checking existing config setup"

# Make sure we initialize the config inside of a potentially new volume
if [ ! -f /config/.gitconfig ]; then
    echo "info    - New install - setting up config"
    # Make sure we own the files and directories
    sudo chown coder:coder /config
    sudo chown coder:coder /home/coder/project

    # create files and subdirectories
    touch /config/.gitconfig
    mkdir -p /config/.ssh

    # set proper permissions
    chmod 740 /config
    chmod 740 /home/coder/project
    chmod 640 /config/.gitconfig
    chmod 740 /config/.ssh

    echo "info    - New install - config setup completed"
else
    echo "info  Existing install - nothing to init"
fi