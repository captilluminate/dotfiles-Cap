#!/bin/bash

# Cap's Dotfiles Installation Script
# Compatible with multiple Linux distributions
# This script creates symlinks from home directory to dotfiles and installs dependencies

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Directories
DOTFILES_DIR="$HOME/.dotfiles-Cap"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d_%H%M%S)"

# Functions
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

# Detect Linux distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
        DISTRO_LIKE=$ID_LIKE
    elif [ -f /etc/redhat-release ]; then
        DISTRO="rhel"
    elif [ -f /etc/debian_version ]; then
        DISTRO="debian"
    else
        DISTRO="unknown"
    fi
    
    log_info "Detected distribution: $DISTRO"
}

# Get package manager command
get_package_manager() {
    case "$DISTRO" in
        "arch"|"endeavouros"|"manjaro")
            PKG_MANAGER="pacman"
            INSTALL_CMD="sudo pacman -S --noconfirm"
            UPDATE_CMD="sudo pacman -Syu --noconfirm"
            ;;
        "ubuntu"|"debian"|"linuxmint"|"pop")
            PKG_MANAGER="apt"
            INSTALL_CMD="sudo apt install -y"
            UPDATE_CMD="sudo apt update && sudo apt upgrade -y"
            ;;
        "fedora"|"rhel"|"centos")
            PKG_MANAGER="dnf"
            INSTALL_CMD="sudo dnf install -y"
            UPDATE_CMD="sudo dnf update -y"
            ;;
        "opensuse"|"sles")
            PKG_MANAGER="zypper"
            INSTALL_CMD="sudo zypper install -y"
            UPDATE_CMD="sudo zypper update -y"
            ;;
        "alpine")
            PKG_MANAGER="apk"
            INSTALL_CMD="sudo apk add"
            UPDATE_CMD="sudo apk update && sudo apk upgrade"
            ;;
        *)
            # Check for common package managers if distro detection failed
            if command -v pacman >/dev/null 2>&1; then
                PKG_MANAGER="pacman"
                INSTALL_CMD="sudo pacman -S --noconfirm"
                UPDATE_CMD="sudo pacman -Syu --noconfirm"
            elif command -v apt >/dev/null 2>&1; then
                PKG_MANAGER="apt"
                INSTALL_CMD="sudo apt install -y"
                UPDATE_CMD="sudo apt update && sudo apt upgrade -y"
            elif command -v dnf >/dev/null 2>&1; then
                PKG_MANAGER="dnf"
                INSTALL_CMD="sudo dnf install -y"
                UPDATE_CMD="sudo dnf update -y"
            elif command -v zypper >/dev/null 2>&1; then
                PKG_MANAGER="zypper"
                INSTALL_CMD="sudo zypper install -y"
                UPDATE_CMD="sudo zypper update -y"
            elif command -v apk >/dev/null 2>&1; then
                PKG_MANAGER="apk"
                INSTALL_CMD="sudo apk add"
                UPDATE_CMD="sudo apk update && sudo apk upgrade"
            else
                log_warning "Could not detect package manager. Package installation will be skipped."
                PKG_MANAGER="unknown"
            fi
            ;;
    esac
    
    if [ "$PKG_MANAGER" != "unknown" ]; then
        log_info "Using package manager: $PKG_MANAGER"
    fi
}

# Install dependencies based on distribution
install_dependencies() {
    if [ "$PKG_MANAGER" = "unknown" ]; then
        log_warning "Skipping dependency installation - unknown package manager"
        return
    fi
    
    log_info "Installing/updating system packages..."
    
    # Essential packages that should be available on most distros
    local essential_packages=()
    local optional_packages=()
    
    case "$PKG_MANAGER" in
        "pacman")
            essential_packages=("git" "curl" "wget" "unzip" "base-devel")
            optional_packages=("neovim" "kitty" "alacritty" "rofi" "starship" "zsh" "fish")
            ;;
        "apt")
            essential_packages=("git" "curl" "wget" "unzip" "build-essential")
            optional_packages=("neovim" "kitty" "rofi" "zsh" "fish")
            ;;
        "dnf")
            essential_packages=("git" "curl" "wget" "unzip" "@development-tools")
            optional_packages=("neovim" "kitty" "rofi" "starship" "zsh" "fish")
            ;;
        "zypper")
            essential_packages=("git" "curl" "wget" "unzip" "patterns-devel-base-devel_basis")
            optional_packages=("neovim" "kitty" "rofi" "zsh" "fish")
            ;;
        "apk")
            essential_packages=("git" "curl" "wget" "unzip" "build-base")
            optional_packages=("neovim" "kitty" "zsh" "fish")
            ;;
    esac
    
    # Install essential packages
    if [ ${#essential_packages[@]} -gt 0 ]; then
        log_info "Installing essential packages..."
        eval "$INSTALL_CMD ${essential_packages[*]}" || log_warning "Some essential packages failed to install"
    fi
    
    # Ask about optional packages
    echo
    read -p "Install optional packages (neovim, terminals, shells, etc.)? [y/N]: " -r install_optional
    if [[ $install_optional =~ ^[Yy]$ ]]; then
        if [ ${#optional_packages[@]} -gt 0 ]; then
            log_info "Installing optional packages..."
            eval "$INSTALL_CMD ${optional_packages[*]}" || log_warning "Some optional packages failed to install"
        fi
    fi
}

# Check if required directories exist
check_requirements() {
    if [ ! -d "$DOTFILES_DIR" ]; then
        log_error "Dotfiles directory not found: $DOTFILES_DIR"
        log_info "Please run this script from the dotfiles directory or clone the repository first:"
        log_info "git clone https://github.com/captilluminate/dotfiles-Cap.git ~/.dotfiles-Cap"
        exit 1
    fi
    
    log_success "Found dotfiles directory: $DOTFILES_DIR"
}

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Cap's Universal Dotfiles Installer  ${NC}"
echo -e "${BLUE}========================================${NC}"
echo

# Detect system
detect_distro
get_package_manager
check_requirements

# Ask user what to install
echo
log_info "What would you like to do?"
echo "1) Install dependencies + dotfiles (recommended)"
echo "2) Install dotfiles only"
echo "3) Install dependencies only"
read -p "Enter your choice [1-3]: " -r choice

case $choice in
    1)
        install_dependencies
        INSTALL_DOTFILES=true
        ;;
    2)
        INSTALL_DOTFILES=true
        ;;
    3)
        install_dependencies
        INSTALL_DOTFILES=false
        ;;
    *)
        log_info "Installing both dependencies and dotfiles (default)"
        install_dependencies
        INSTALL_DOTFILES=true
        ;;
esac

if [ "$INSTALL_DOTFILES" = "false" ]; then
    log_success "Dependencies installation complete!"
    exit 0
fi

log_info "Installing dotfiles..."

# Create backup directory
mkdir -p "$BACKUP_DIR"
log_info "Backup directory created: $BACKUP_DIR"

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
if [ -f "$DOTFILES_DIR/config/starship.toml" ]; then
    backup_and_link "$DOTFILES_DIR/config/starship.toml" "$CONFIG_DIR/starship.toml"
fi

# Post-installation setup
post_install_setup() {
    log_info "Running post-installation setup..."
    
    # Install starship if not present and user wants it
    if ! command -v starship >/dev/null 2>&1; then
        echo
        read -p "Starship prompt not found. Install it? [y/N]: " -r install_starship
        if [[ $install_starship =~ ^[Yy]$ ]]; then
            log_info "Installing Starship..."
            if command -v curl >/dev/null 2>&1; then
                curl -sS https://starship.rs/install.sh | sh -s -- --yes
            else
                log_warning "curl not found. Please install starship manually: https://starship.rs/guide/#step-1-install-starship"
            fi
        fi
    fi
    
    # Set up shell configurations
    setup_shell_integration
    
    # Make scripts executable
    find "$DOTFILES_DIR" -name "*.sh" -type f -exec chmod +x {} \; 2>/dev/null || true
    
    # Set up git hooks if .git directory exists
    if [ -d "$DOTFILES_DIR/.git" ]; then
        log_info "Setting up git hooks..."
        # Add a pre-commit hook to ensure scripts remain executable
        mkdir -p "$DOTFILES_DIR/.git/hooks"
        cat > "$DOTFILES_DIR/.git/hooks/pre-commit" << 'EOF'
#!/bin/bash
# Ensure shell scripts are executable
find . -name "*.sh" -type f -exec chmod +x {} \;
EOF
        chmod +x "$DOTFILES_DIR/.git/hooks/pre-commit"
    fi
}

# Shell integration setup
setup_shell_integration() {
    local current_shell
    current_shell="$(basename "$SHELL")"
    
    log_info "Current shell: $current_shell"
    
    # Check if shell config files exist and are properly linked
    case "$current_shell" in
        "bash")
            if [ -L "$HOME/.bashrc" ] && [ "$(readlink "$HOME/.bashrc")" = "$DOTFILES_DIR/home/.bashrc" ]; then
                log_success "Bash configuration is properly linked"
            else
                log_warning "Bash configuration may not be properly linked"
            fi
            ;;
        "zsh")
            if [ -L "$HOME/.zshrc" ] && [ "$(readlink "$HOME/.zshrc")" = "$DOTFILES_DIR/home/.zshrc" ]; then
                log_success "Zsh configuration is properly linked"
            else
                log_warning "Zsh configuration may not be properly linked"
            fi
            # Check if zsh is set as default shell
            if [ "$SHELL" != "$(which zsh)" ] && command -v zsh >/dev/null 2>&1; then
                echo
                read -p "Set zsh as your default shell? [y/N]: " -r set_zsh
                if [[ $set_zsh =~ ^[Yy]$ ]]; then
                    chsh -s "$(which zsh)"
                    log_success "Default shell changed to zsh. Please log out and back in for changes to take effect."
                fi
            fi
            ;;
        "fish")
            log_info "Fish shell detected. Note: Fish uses different configuration format."
            if command -v fish >/dev/null 2>&1; then
                log_info "Consider adapting the configurations for Fish shell manually."
            fi
            ;;
    esac
}

# System-specific recommendations
show_recommendations() {
    echo
    log_info "System-specific recommendations:"
    
    case "$DISTRO" in
        "arch"|"endeavouros"|"manjaro")
            echo "  • Consider installing: yay (AUR helper), ttf-nerd-fonts-symbols"
            echo "  • For Hyprland: hyprland-git, waybar-hyprland, swww"
            ;;
        "ubuntu"|"debian"|"linuxmint")
            echo "  • Consider installing: flatpak, snap (if not already installed)"
            echo "  • For newer versions of packages, consider using PPAs or Flatpak"
            ;;
        "fedora")
            echo "  • Consider enabling RPM Fusion repositories"
            echo "  • Flatpak is pre-installed and recommended for additional software"
            ;;
    esac
    
    if command -v nvim >/dev/null 2>&1; then
        echo "  • Neovim detected. Your nvim config will use the LazyVim setup"
        echo "  • Run 'nvim' to initialize plugins on first launch"
    fi
    
    if [ -d "$CONFIG_DIR/hypr" ]; then
        echo "  • Hyprland config installed. Make sure Hyprland is installed to use it"
    fi
    
    echo "  • Reboot or log out/in to ensure all changes take effect"
}

# Run post-installation setup
post_install_setup

log_success "Dotfiles installation complete!"
log_info "Backup directory: $BACKUP_DIR"

# Show current shell reload instructions
echo
log_info "To reload your current shell configuration:"
case "$(basename "$SHELL")" in
    "bash")
        echo "  source ~/.bashrc"
        ;;
    "zsh")
        echo "  source ~/.zshrc"
        ;;
    "fish")
        echo "  source ~/.config/fish/config.fish"
        ;;
    *)
        echo "  source ~/.bashrc  # for bash"
        echo "  source ~/.zshrc   # for zsh"
        ;;
esac

# Show recommendations
show_recommendations

echo
log_success "Installation completed successfully! 🎉"
log_info "Repository: https://github.com/captilluminate/dotfiles-Cap"
