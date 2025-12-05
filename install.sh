#!/bin/bash

# --- Variables ---
BASHRC_SOURCE="bashrc-skugge"
VIMRC_SOURCE="vimrc"
BASHRC_SIGNATURE=$(md5sum "$BASHRC_SOURCE" 2>/dev/null | awk '{print $1}')
BASHRC_DEST="$HOME/.bashrc"
VIM_COLORS_DIR="$HOME/.vim/colors"
VIMRC_DEST="$HOME/.vimrc"
FONTS_DEST="$HOME/.local/share/fonts"

# --- Functions ---

# Help function
show_help() {
cat << EOF
Usage: $0 [OPTIONS]

This script installs configuration files for bash, vim, and fonts.

Options:
  -a, --all        Install all configurations (Bash, Vim, and Fonts). This is the default if no options are specified.
  -d, --default    Install the standard configuration (Bash and Vim only).

  -b, --bashrc     Install only the custom ~/.bashrc
  -v, --vim        Install only vim configuration (~/.vimrc and colors)
  -f, --fonts      Install only custom fonts and update font cache
  -h, --help       Display this help message and exit
EOF
}

# Install Bashrc function
install_bashrc() {
    echo "[+] Configuring ~/.bashrc"
    if [ -z "$BASHRC_SIGNATURE" ]; then
        echo "Error: Source file '$BASHRC_SOURCE' not found. Skipping ~/.bashrc installation."
        return 1
    fi
    if [[ -f "$BASHRC_DEST" ]] && [[ "$(md5sum "$BASHRC_DEST" 2>/dev/null | awk '{print $1}')" == "$BASHRC_SIGNATURE" ]]; then
        echo "~/.bashrc is already your configuration, skipping move and copy."
    else
        if [[ -f "$BASHRC_DEST" ]]; then
            echo "Backing up current $BASHRC_DEST to $BASHRC_DEST.bak"
            mv "$BASHRC_DEST" "$BASHRC_DEST.bak"
        fi
        echo "Copying $BASHRC_SOURCE to $BASHRC_DEST"
        cp "$BASHRC_SOURCE" "$BASHRC_DEST"
    fi
    echo "---"
}

# Install Vim function
install_vim() {
    echo "[+] Configuring Vim"
    if [[ ! -d "$VIM_COLORS_DIR" ]]; then
        echo "Creating $VIM_COLORS_DIR"
        mkdir -p "$VIM_COLORS_DIR"
    fi
    if compgen -G "vimcolors/*.vim" > /dev/null; then
        echo "Copying vim color schemes to $VIM_COLORS_DIR"
        cp vimcolors/*.vim "$VIM_COLORS_DIR"/
    else
        echo "Warning: No vim color schemes found in 'vimcolors/'. Skipping color scheme copy."
    fi
    if [[ -f "$VIMRC_SOURCE" ]]; then
        echo "Copying $VIMRC_SOURCE to $VIMRC_DEST"
        cp "$VIMRC_SOURCE" "$VIMRC_DEST"
    else
        echo "Error: Source file '$VIMRC_SOURCE' not found. Skipping ~/.vimrc installation."
    fi
    echo "---"
}

# Install Fonts function
install_fonts() {
    echo "[+] Installing Fonts"
    if [[ ! -d "$FONTS_DEST" ]]; then
        echo "Creating $FONTS_DEST"
        mkdir -p "$FONTS_DEST"
    fi
    if compgen -G "fonts/*.ttf" > /dev/null; then
        echo "Copying .ttf fonts to $FONTS_DEST"
        cp ./fonts/*.ttf "$FONTS_DEST"/
        
        echo "Updating font cache..."
        fc-cache -f -v
        echo "Font installation complete."
    else
        echo "Warning: No .ttf fonts found in 'fonts/'. Skipping font installation and cache update."
    fi
    echo "---"
}

# --- Main Logic ---

# Initialize all flags to false, then set based on options
INSTALL_BASHRC=false
INSTALL_VIM=false
INSTALL_FONTS=false
SPECIFIED_OPTIONS=false

# Process options
while getopts ":a d b v f h" opt; do
    SPECIFIED_OPTIONS=true
    case $opt in
        a) # Install All: Bash, Vim, Fonts
            INSTALL_BASHRC=true
            INSTALL_VIM=true
            INSTALL_FONTS=true
            ;;
        d) # Install Default: Bash, Vim
            INSTALL_BASHRC=true
            INSTALL_VIM=true
            INSTALL_FONTS=false
            ;;
        b) # Install only Bash
            INSTALL_BASHRC=true
            INSTALL_VIM=false
            INSTALL_FONTS=false
            ;;
        v) # Install only Vim
            INSTALL_BASHRC=false
            INSTALL_VIM=true
            INSTALL_FONTS=false
            ;;
        f) # Install only Fonts
            INSTALL_BASHRC=false
            INSTALL_VIM=false
            INSTALL_FONTS=true
            ;;
        h)
            show_help
            exit 0
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            show_help
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            show_help
            exit 1
            ;;
    esac
done

# If NO options were specified, default to '-a' (Install All)
if ! $SPECIFIED_OPTIONS; then
    INSTALL_BASHRC=true
    INSTALL_VIM=true
    INSTALL_FONTS=true
    echo "No options specified. Running default behavior: **Install All** (-a)."
fi


# Execute installations based on flags
echo "--- Starting Configuration Installation ---"

if $INSTALL_BASHRC; then
    install_bashrc
fi

if $INSTALL_VIM; then
    install_vim
fi

if $INSTALL_FONTS; then
    install_fonts
fi

# --- Summary ---
echo "--- Installation Summary ---"
echo "Bashrc: $($INSTALL_BASHRC && echo 'Installed' || echo 'Skipped')"
echo "Vim Config: $($INSTALL_VIM && echo 'Installed' || echo 'Skipped')"
echo "Fonts: $($INSTALL_FONTS && echo 'Installed' || echo 'Skipped')"

echo ""
echo "[+] Installation complete! You can now run ./start-tmux.sh <tmux-config-file>"
