#!/bin/bash

set -e

DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

sudo pacman -Syu
sudo pacman -S --needed base-devel git rsync

sudo pacman -S --needed zsh
sudo pacman -S --needed zsh-theme-powerlevel10k
mkdir -p ~/.zsh
mkdir -p ~/.zsh/plugins
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions $HOME/.zsh/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.zsh/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.zsh/plugins/powerlevel10k

# tmux
sudo pacman -S --nedeed tmux
git clone --depth=1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
mkdir -p ~/.local/share/tmux/resurrect
~/.tmux/plugins/tpm/bin/install_plugins

if [[ -s "$DIR/packages.txt" ]]; then
    sudo pacman -S --needed - < "$DIR/packages.txt"
fi

if ! command -v yay >/dev/null 2>&1; then
    echo "==> Installing yay"
    TMP="$(mktemp -d)"
    git clone https://aur.archlinux.org/yay-bin.git "$TMP/yay-bin"

    (
        cd "$TMP/yay-bin"
        makepkg -si
    )

    rm -rf "$TMP"
fi

if [[ -s "$DIR/packages-aur.txt" ]]; then
    yay -S --needed - < "$DIR/packages-aur.txt"
fi



