#!/bin/bash

# Check if the first argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <tmux-config-file>"
    exit 1
fi

CONFIG_FILE="$1"

# Start tmux with the specified configuration file
tmux -f "$CONFIG_FILE"
