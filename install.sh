#!/bin/bash

SIGNATURE=$(md5sum bashrc-skugge | awk '{print $1}')

# Replace default ~/.bashrc if different from your signature
if [[ ! $(md5sum ~/.bashrc | awk '{print $1}') == "$SIGNATURE" ]]; then
    echo "Backing up current ~/.bashrc to ~/.bashrc.bak"
    mv ~/.bashrc ~/.bashrc.bak
    cp bashrc-skugge ~/.bashrc
else
    echo "~/.bashrc is already yours, skipping move and copy."
fi

# Create vim colors directory if it doesn't exist
if [[ ! -d ~/.vim/colors ]]; then
    mkdir -p ~/.vim/colors
fi

# Copy all vim color schemes
cp *.vim ~/.vim/colors/

# Copy vimrc to home
cp vimrc ~/.vimrc

echo "Installation complete! You can now run ./start-tmux.sh <tmux-config-file>"
