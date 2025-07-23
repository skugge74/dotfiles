#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 [-t <tmux-config-file>] [-v <vim-files-directory>]"
    exit 1
}

# Initialize variables
TMUX_CONFIG_FILE=""
VIM_FILES_DIR=""

# Parse options
while getopts ":t:v:" opt; do
    case $opt in
        t)
            TMUX_CONFIG_FILE="$OPTARG"
            ;;
        v)
            VIM_FILES_DIR="$OPTARG"
            ;;
        *)
            usage
            ;;
    esac
done

# Check if tmux config file is provided
if [ -z "$TMUX_CONFIG_FILE" ]; then
    echo "Error: tmux config file must be specified with -t."
    usage
fi

SIGNATURE=$(md5sum bashrc-skugge | awk '{ print $1 }')

# Check if the tmux config file exists
if [ ! -f "$TMUX_CONFIG_FILE" ]; then
    echo "Error: File '$TMUX_CONFIG_FILE' not found."
    exit 1
fi

# Check if the tmux config file has a .conf extension
if [[ ! "$TMUX_CONFIG_FILE" == *.conf ]]; then
    echo "Error: tmux configuration file must have a .conf extension."
    exit 1
fi

# Replace default bashrc if necessary
if [[ ! $(md5sum ~/.bashrc | awk '{ print $1 }') == "$SIGNATURE" ]]; then
    # If the signature is not found, move and copy the files
    mv ~/.bashrc ~/.bashrc.bak
    cp bashrc-skugge ~/.bashrc
else
    echo "~/.bashrc is already yours, skipping move and copy."
fi

# Copy all Vim files if directory is provided
if [ -n "$VIM_FILES_DIR" ]; then
    if [[ ! -d "$VIM_FILES_DIR" ]]; then
        echo "Error: Directory '$VIM_FILES_DIR' not found."
        exit 1
    fi

    # Create Vim colors directory if it doesn't exist
    if [[ ! -d ~/.vim/colors ]]; then
        mkdir -p ~/.vim/colors
    fi

    # Copy Vim color files
    cp "$VIM_FILES_DIR"/*.vim ~/.vim/colors/
    echo "Copied Vim files from '$VIM_FILES_DIR' to '~/.vim/colors/'."
fi

# Copy the tmux configuration file
cp "$TMUX_CONFIG_FILE" ~/.tmux.conf
echo "Copied tmux configuration file '$TMUX_CONFIG_FILE' to '~/.tmux.conf'."
