#!/bin/bash

# Check if the first argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <tmux-config-file>"
    exit 1
fi

CONFIG_FILE="$1"

# Check if the file has a .conf extension
if [[ ! "$CONFIG_FILE" == *.conf ]]; then
    echo "Error: Configuration file must have a .conf extension."
    exit 1
fi

# Check if the file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: File '$CONFIG_FILE' not found."
    exit 1
fi

# Set the PS1 prompt with the specified format
export PS1='[\[\e[38;5;160m\]\A\[\e[0m\]](\[\e[38;5;125m\]\u\[\e[0m\])[\[\e[38;5;240m\]\w\[\e[0m\]]\$ '

# Start tmux with the specified configuration file
tmux -f "$CONFIG_FILE"
