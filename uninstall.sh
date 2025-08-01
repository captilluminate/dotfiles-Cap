#!/bin/bash

# Cap's Dotfiles Uninstall Script
# This script removes symlinks and optionally restores backups

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

DOTFILES_DIR="$HOME/.dotfiles-Cap"
CONFIG_DIR="$HOME/.config"

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Cap's Dotfiles Uninstaller          ${NC}"
echo -e "${BLUE}========================================${NC}"
echo

# Check if dotfiles directory exists
if [ ! -d "$DOTFILES_DIR" ]; then
    log_error "Dotfiles directory not found: $DOTFILES_DIR"
    exit 1
fi

log_warning "This will remove all symlinks created by the dotfiles installer."
echo
read -p "Are you sure you want to continue? [y/N]: " -r confirm
if [[ ! $confirm =~ ^[Yy]$ ]]; then
    log_info "Uninstall cancelled."
    exit 0
fi

# Function to remove symlink if it points to our dotfiles
remove_symlink() {
    local target="$1"
    local expected_source="$2"
    
    if [ -L "$target" ]; then
        local current_source
        current_source="$(readlink "$target")"
        if [ "$current_source" = "$expected_source" ]; then
            log_info "Removing symlink: $target"
            rm "$target"
            return 0
        else
            log_warning "Symlink $target points to $current_source (not our dotfiles), skipping"
            return 1
        fi
    elif [ -e "$target" ]; then
        log_warning "$target exists but is not a symlink, skipping"
        return 1
    else
        log_info "$target does not exist, skipping"
        return 1
    fi
}

# Remove home directory symlinks
log_info "Removing home directory symlinks..."
remove_symlink "$HOME/.bashrc" "$DOTFILES_DIR/home/.bashrc"
remove_symlink "$HOME/.zshrc" "$DOTFILES_DIR/home/.zshrc"
remove_symlink "$HOME/.gitconfig" "$DOTFILES_DIR/home/.gitconfig"
remove_symlink "$HOME/.spacemacs" "$DOTFILES_DIR/home/.spacemacs"
remove_symlink "$HOME/.Xresources" "$DOTFILES_DIR/home/.Xresources"

# Remove config directory symlinks
log_info "Removing config directory symlinks..."
for config_dir in nvim hypr waybar kitty alacritty rofi; do
    remove_symlink "$CONFIG_DIR/$config_dir" "$DOTFILES_DIR/config/$config_dir"
done

remove_symlink "$CONFIG_DIR/starship.toml" "$DOTFILES_DIR/config/starship.toml"

echo
log_info "Checking for backup directories..."

# Find backup directories
backup_dirs=($(find "$HOME" -maxdepth 1 -name ".dotfiles-backup-*" -type d 2>/dev/null | sort -r))

if [ ${#backup_dirs[@]} -eq 0 ]; then
    log_info "No backup directories found."
else
    echo "Found ${#backup_dirs[@]} backup directories:"
    for i in "${!backup_dirs[@]}"; do
        echo "  $((i+1))) $(basename "${backup_dirs[$i]}")"
    done
    echo
    read -p "Restore files from a backup? Enter number (or 'n' to skip): " -r backup_choice
    
    if [[ $backup_choice =~ ^[0-9]+$ ]] && [ "$backup_choice" -ge 1 ] && [ "$backup_choice" -le "${#backup_dirs[@]}" ]; then
        selected_backup="${backup_dirs[$((backup_choice-1))]}"
        log_info "Restoring files from: $(basename "$selected_backup")"
        
        # Restore files from backup
        for file in "$selected_backup"/*; do
            if [ -f "$file" ]; then
                filename="$(basename "$file")"
                target="$HOME/$filename"
                
                if [ -e "$target" ]; then
                    log_warning "$target already exists, skipping restore"
                else
                    log_info "Restoring: $filename"
                    cp "$file" "$target"
                fi
            fi
        done
        
        # Also check for config files in backup
        for file in "$selected_backup"/*; do
            if [ -f "$file" ]; then
                filename="$(basename "$file")"
                # Check if this might be a config file
                if [[ "$filename" =~ ^(starship\.toml|mimeapps\.list)$ ]]; then
                    target="$CONFIG_DIR/$filename"
                    if [ -e "$target" ]; then
                        log_warning "$target already exists, skipping restore"
                    else
                        log_info "Restoring config: $filename"
                        mkdir -p "$CONFIG_DIR"
                        cp "$file" "$target"
                    fi
                fi
            fi
        done
        
        log_success "Files restored from backup"
    fi
fi

echo
read -p "Remove the dotfiles directory ($DOTFILES_DIR)? [y/N]: " -r remove_dotfiles
if [[ $remove_dotfiles =~ ^[Yy]$ ]]; then
    log_info "Removing dotfiles directory..."
    rm -rf "$DOTFILES_DIR"
    log_success "Dotfiles directory removed"
else
    log_info "Dotfiles directory preserved"
fi

echo
read -p "Remove backup directories? [y/N]: " -r remove_backups
if [[ $remove_backups =~ ^[Yy]$ ]] && [ ${#backup_dirs[@]} -gt 0 ]; then
    for backup_dir in "${backup_dirs[@]}"; do
        log_info "Removing backup: $(basename "$backup_dir")"
        rm -rf "$backup_dir"
    done
    log_success "Backup directories removed"
fi

echo
log_success "Uninstall completed! 🗑️"
log_info "You may want to reload your shell or log out/in to see changes"
