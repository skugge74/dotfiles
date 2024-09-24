#!/bin/bash

# Check if the first argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <tmux-config-file>"
    exit 1
fi

CONFIG_FILE="$1"
SIGNATURE=$(md5sum bashrc-skugge)

# Check if the file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: File '$CONFIG_FILE' not found."
    exit 1
fi

# Check if the file has a .conf extension
if [[ ! "$CONFIG_FILE" == *.conf ]]; then
    echo "Error: Configuration file must have a .conf extension."
    exit 1
fi

#replace default bashrc
# Check if ~/.bashrc contains the signature #SKUGGE74 at the beginning
#if ! grep -q '^#SKUGGE74' ~/.bashrc; then
 if [[ ! $(md5sum ~/.bashrc) == '$SIGNATURE' ]]; then
    # If the signature is not found, move and copy the files
    mv ~/.bashrc ~/.bashrc.bak
    cp bashrc-skugge ~/.bashrc
else
    echo "~/.bashrc is already yours, skipping move and copy."
fi

# Check if ~/.vim/colors exists
if [ -d ~/.vim/colors ]; then
    mv catppuccin_mocha.vim ~/.vim/colors/
else
    # Create the directory if it doesn't exist
    mkdir -p ~/.vim/colors
    cp catppuccin_mocha.vim ~/.vim/colors/
fi

cp vimrc ~/.vimrc

# Start tmux with the specified configuration file
tmux -f "$CONFIG_FILE"
