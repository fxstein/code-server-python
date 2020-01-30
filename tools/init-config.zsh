#!/usr/bin/env zsh

# Make sure we initialize the config inside of a potentially new volume
if [ ! -f /home/coder/.config/.gitconfig ]; then
    # Make sure we own the files and directories
    chown coder:coder /home/coder/.config
    chown coder:coder /home/coder/project

    # create files and subdirectories
    touch /home/coder/.config/.gitconfig
    mkdir -p /home/coder/.config/.ssh

    # set proper permissions
    chmod 740 /home/coder/.config
    chmod 740 /home/coder/project
    chmod 640 /home/coder/.config/.gitconfig
    chmod 640 /home/coder/.config/.ssh
fi