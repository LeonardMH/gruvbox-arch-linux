#!/bin/bash

# Gruvbox Dotfiles Install Script
# Installs Gruvbox-themed configuration files via symbolic links

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Function to show dependency installation instructions
show_dependencies() {
    echo "==================================================================="
    echo "                    DEPENDENCY INSTALLATION                        "
    echo "==================================================================="
    echo ""
    echo "Required packages from official Arch repositories (pacman):"
    echo ""
    echo "  sudo pacman -S hyprland waybar swaync foot fuzzel swaylock \\"
    echo "                 fzf zsh ttf-jetbrains-mono-nerd \\"
    echo "                 brightnessctl playerctl grim slurp wl-clipboard \\"
    echo "                 swaybg pactl neovim tree-sitter"
    echo ""
    echo "Optional packages from AUR (yay):"
    echo ""
    echo "  yay -S ncspot hypridle hyprlock"
    echo ""
    echo "Oh My Zsh installation (if not already installed):"
    echo ""
    echo "  sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""
    echo ""
    echo "ZSH plugins (after Oh My Zsh is installed):"
    echo ""
    echo "  git clone https://github.com/zsh-users/zsh-autosuggestions \\"
    echo "    \${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
    echo ""
    echo "  git clone https://github.com/zsh-users/zsh-syntax-highlighting \\"
    echo "    \${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
    echo ""
    echo "==================================================================="
    echo ""
    echo "Press Enter to continue with dotfiles installation..."
    read -r
}

# Parse command line arguments
if [[ "$1" == "--deps" ]] || [[ "$1" == "-d" ]]; then
    show_dependencies
elif [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
    echo "Gruvbox Dotfiles Installer"
    echo ""
    echo "Usage: ./install.sh [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --deps, -d    Show dependency installation commands before proceeding"
    echo "  --help, -h    Show this help message"
    echo ""
    echo "Without options, the script will install dotfiles directly."
    exit 0
fi

echo "Installing Gruvbox Dotfiles..."
echo "Dotfiles directory: $DOTFILES_DIR"
echo "Backup directory: $BACKUP_DIR"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Function to backup and link files
backup_and_link() {
    local source="$1"
    local target="$2"
    local target_dir="$(dirname "$target")"

    # Create target directory if it doesn't exist
    mkdir -p "$target_dir"

    # Backup existing file if it exists and isn't already a symlink to our dotfiles
    if [[ -e "$target" && ! -L "$target" ]]; then
        echo "Backing up existing $target"
        mv "$target" "$BACKUP_DIR/$(basename "$target")"
    elif [[ -L "$target" ]]; then
        # Remove existing symlink
        rm "$target"
    fi

    # Create symlink
    echo "Linking $source -> $target"
    ln -s "$source" "$target"
}

# Copy a template to a target only if the target doesn't exist. Used for
# files that contain secrets and therefore can't be symlinked from the
# public dotfiles repo (e.g. wayvnc config with a password).
install_template() {
    local source="$1"
    local target="$2"
    local target_dir="$(dirname "$target")"

    mkdir -p "$target_dir"

    if [[ -e "$target" ]]; then
        echo "Skipping $target (already exists — edit in place if needed)"
        return
    fi

    echo "Copying template $source -> $target"
    cp "$source" "$target"
    chmod 600 "$target"
    echo "  ! Edit $target and replace ADDRESS and PASSWORD before use"
}

echo "Installing configuration files..."

# Hyprland configs
backup_and_link "$DOTFILES_DIR/hypr/hyprland.conf" "$HOME/.config/hypr/hyprland.conf"
backup_and_link "$DOTFILES_DIR/hypr/hyprlock.conf" "$HOME/.config/hypr/hyprlock.conf"
backup_and_link "$DOTFILES_DIR/hypr/hypridle.conf" "$HOME/.config/hypr/hypridle.conf"

# Waybar configs
backup_and_link "$DOTFILES_DIR/waybar/config" "$HOME/.config/waybar/config"
backup_and_link "$DOTFILES_DIR/waybar/style.css" "$HOME/.config/waybar/style.css"

# SwayNC configs
backup_and_link "$DOTFILES_DIR/swaync/config.json" "$HOME/.config/swaync/config.json"
backup_and_link "$DOTFILES_DIR/swaync/style.css" "$HOME/.config/swaync/style.css"

# Terminal and launcher configs
backup_and_link "$DOTFILES_DIR/foot/foot.ini" "$HOME/.config/foot/foot.ini"
backup_and_link "$DOTFILES_DIR/fuzzel/fuzzel.ini" "$HOME/.config/fuzzel/fuzzel.ini"

# GTK theming
backup_and_link "$DOTFILES_DIR/gtk-3.0/gtk.css" "$HOME/.config/gtk-3.0/gtk.css"

# Application configs
backup_and_link "$DOTFILES_DIR/ncspot/config.toml" "$HOME/.config/ncspot/config.toml"
backup_and_link "$DOTFILES_DIR/swaylock/config" "$HOME/.config/swaylock/config"

# wayvnc — template copy (not symlink) because the real config contains a
# password. See wayvnc/config.template for the one-time setup steps.
install_template "$DOTFILES_DIR/wayvnc/config.template" "$HOME/.config/wayvnc/config"

# Sway configs
backup_and_link "$DOTFILES_DIR/sway/config.d/gruvbox.conf" "$HOME/.config/sway/config.d/gruvbox.conf"

# ZSH configs
backup_and_link "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"
backup_and_link "$DOTFILES_DIR/zsh/themes/gruvbox.zsh-theme" "$HOME/.oh-my-zsh/themes/gruvbox.zsh-theme"

# Neovim config
backup_and_link "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

echo "Installation complete!"
echo ""
echo "Next steps:"
echo "   1. Restart your terminal or run 'source ~/.zshrc'"
echo "   2. Restart Waybar: 'killall waybar && waybar &'"
echo "   3. Reload Hyprland config: 'hyprctl reload'"
echo "   4. Open neovim and run :Lazy to install plugins, then :MasonInstall <server> for LSP"
echo ""
echo "Your system now uses the Gruvbox color scheme!"
echo ""
echo "Run './install.sh --deps' to see required package installation commands."

if [[ -d "$BACKUP_DIR" && $(ls -A "$BACKUP_DIR") ]]; then
    echo "Original files backed up to: $BACKUP_DIR"
else
    rmdir "$BACKUP_DIR" 2>/dev/null || true
fi