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

### Quick Install (Recommended)

```bash
# Clone and install in one command
git clone https://github.com/captilluminate/dotfiles-Cap.git ~/.dotfiles-Cap && cd ~/.dotfiles-Cap && ./install.sh
```

### Manual Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/captilluminate/dotfiles-Cap.git ~/.dotfiles-Cap
   ```

2. Run the universal installation script:
   ```bash
   cd ~/.dotfiles-Cap
   ./install.sh
   ```

### What the installer does:

- **🔍 Auto-detects your Linux distribution** (Arch, Ubuntu, Debian, Fedora, openSUSE, Alpine, etc.)
- **📦 Installs dependencies** using your system's package manager (pacman, apt, dnf, zypper, apk)
- **🔗 Creates symlinks** from your home directory to the dotfiles
- **💾 Creates backups** of existing configurations with timestamps
- **🎨 Offers to install** optional packages (Neovim, terminals, shells, etc.)
- **⚙️ Post-install setup** including Starship prompt installation and shell integration

### Installation Options:

1. **Dependencies + Dotfiles** (recommended) - Full setup with package installation
2. **Dotfiles only** - Just symlink configurations (if you have packages already)
3. **Dependencies only** - Install packages without linking configs

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

## Supported Distributions

The installer automatically detects and supports:

| Distribution | Package Manager | Status |
|-------------|-----------------|--------|
| **Arch Linux** | pacman | ✅ Full support |
| **EndeavourOS** | pacman | ✅ Full support |
| **Manjaro** | pacman | ✅ Full support |
| **Ubuntu** | apt | ✅ Full support |
| **Debian** | apt | ✅ Full support |
| **Linux Mint** | apt | ✅ Full support |
| **Pop!_OS** | apt | ✅ Full support |
| **Fedora** | dnf | ✅ Full support |
| **RHEL/CentOS** | dnf | ✅ Full support |
| **openSUSE** | zypper | ✅ Full support |
| **Alpine Linux** | apk | ✅ Full support |
| **Other** | auto-detect | ⚠️ Limited support |

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

## Uninstallation

To remove the dotfiles and optionally restore backups:

```bash
cd ~/.dotfiles-Cap
./uninstall.sh
```

The uninstall script will:
- Remove all symlinks created by the installer
- Optionally restore files from backup directories
- Optionally remove the dotfiles directory and backups

## Troubleshooting

### Package Manager Not Detected
If your distribution isn't automatically detected, the installer will attempt to find common package managers. You can still install dotfiles manually by choosing option 2.

### Symlink Issues
If symlinks aren't created properly, check:
- File permissions on the dotfiles directory
- Whether target files already exist (they'll be backed up automatically)

### Shell Configuration
After installation, reload your shell:
```bash
# For Bash
source ~/.bashrc

# For Zsh  
source ~/.zshrc

# Or start a new shell session
exec $SHELL
```

## Contributing

Feel free to fork this repository and adapt it for your own use!

### Adding Support for New Distributions

To add support for a new distribution:

1. Update the `get_package_manager()` function in `install.sh`
2. Add the distribution to the supported list in this README
3. Test the installation on the target distribution
4. Submit a pull request

## License

This project is open source and available under the [MIT License](LICENSE).
