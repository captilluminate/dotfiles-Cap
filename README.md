# Cap's Dotfiles

This repository contains my personal configuration files for various applications and development tools.

## What's Included

### Home Directory Files
- `.bashrc` - Bash shell configuration
- `.zshrc` - Zsh shell configuration  
- `.gitconfig` - Git configuration
- `.spacemacs` - Spacemacs configuration
- `.Xresources` - X11 resource configuration

### Config Directory
- `nvim/` - Neovim configuration
- `hypr/` - Hyprland window manager configuration
- `waybar/` - Waybar status bar configuration
- `kitty/` - Kitty terminal configuration
- `alacritty/` - Alacritty terminal configuration
- `rofi/` - Rofi application launcher configuration
- `starship.toml` - Starship prompt configuration

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/captilluminate/dotfiles-Cap.git ~/.dotfiles-Cap
   ```

2. Run the installation script:
   ```bash
   cd ~/.dotfiles-Cap
   ./install.sh
   ```

The installation script will:
- Create backups of existing configuration files
- Create symlinks from your home directory to the dotfiles
- Preserve your existing configurations in a timestamped backup directory

## System Information

- **OS**: EndeavourOS (Arch Linux)
- **Shell**: Bash/Zsh
- **Window Manager**: Hyprland
- **Terminal**: Kitty/Alacritty
- **Editor**: Neovim
- **Prompt**: Starship

## Manual Installation

If you prefer to install configurations manually:

```bash
# Home directory files
ln -sf ~/.dotfiles-Cap/home/.bashrc ~/.bashrc
ln -sf ~/.dotfiles-Cap/home/.zshrc ~/.zshrc
ln -sf ~/.dotfiles-Cap/home/.gitconfig ~/.gitconfig

# Config directory
ln -sf ~/.dotfiles-Cap/config/nvim ~/.config/nvim
ln -sf ~/.dotfiles-Cap/config/hypr ~/.config/hypr
ln -sf ~/.dotfiles-Cap/config/waybar ~/.config/waybar
# ... and so on
```

## Updating

To update your dotfiles:

1. Pull the latest changes:
   ```bash
   cd ~/.dotfiles-Cap
   git pull
   ```

2. Re-run the installation script if needed:
   ```bash
   ./install.sh
   ```

## Contributing

Feel free to fork this repository and adapt it for your own use!
