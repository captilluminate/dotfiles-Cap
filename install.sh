#!/bin/bash

# Cap's Dotfiles Installation Script
# This script creates symlinks from home directory to dotfiles

DOTFILES_DIR="$HOME/.dotfiles-Cap"
CONFIG_DIR="$HOME/.config"

echo "Installing Cap's dotfiles..."

# Create backup directory
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Function to backup and link files
backup_and_link() {
    local source="$1"
    local target="$2"
    
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "Backing up existing $target"
        mv "$target" "$BACKUP_DIR/"
    elif [ -L "$target" ]; then
        echo "Removing existing symlink $target"
        rm "$target"
    fi
    
    echo "Creating symlink: $target -> $source"
    ln -sf "$source" "$target"
}

# Link home directory files
echo "Linking home directory files..."
backup_and_link "$DOTFILES_DIR/home/.bashrc" "$HOME/.bashrc"
backup_and_link "$DOTFILES_DIR/home/.zshrc" "$HOME/.zshrc"
backup_and_link "$DOTFILES_DIR/home/.gitconfig" "$HOME/.gitconfig"
backup_and_link "$DOTFILES_DIR/home/.spacemacs" "$HOME/.spacemacs"
backup_and_link "$DOTFILES_DIR/home/.Xresources" "$HOME/.Xresources"

# Link config directory files
echo "Linking config directory files..."
mkdir -p "$CONFIG_DIR"

# Config directories
for config_dir in nvim hypr waybar kitty alacritty rofi; do
    if [ -d "$DOTFILES_DIR/config/$config_dir" ]; then
        backup_and_link "$DOTFILES_DIR/config/$config_dir" "$CONFIG_DIR/$config_dir"
    fi
done

# Config files
backup_and_link "$DOTFILES_DIR/config/starship.toml" "$CONFIG_DIR/starship.toml"

echo "Dotfiles installation complete!"
echo "Backup directory: $BACKUP_DIR"
echo ""
echo "To reload shell configuration, run:"
echo "  source ~/.bashrc  # for bash"
echo "  source ~/.zshrc   # for zsh"
