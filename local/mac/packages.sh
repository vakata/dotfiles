#!/bin/bash

set -e

DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

if [[ "$OSTYPE" == "darwin"* ]]; then
    xcode-select --install
fi

# brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# zsh
brew install zsh git
ZSH_PATH="$(brew --prefix)/bin/zsh"
if ! grep -qxF "$ZSH_PATH" /etc/shells; then
    echo "$ZSH_PATH" | sudo tee -a /etc/shells
fi
chsh -s "$ZSH_PATH"

mkdir -p ~/.zsh
mkdir -p ~/.zsh/plugins
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions $HOME/.zsh/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.zsh/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.zsh/plugins/powerlevel10k

# tmux
brew install tmux
git clone --depth=1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
mkdir -p ~/.local/share/tmux/resurrect
~/.tmux/plugins/tpm/bin/install_plugins

brew bundle --file="$DIR/brewfile"

brew services start httpd
brew services start php
brew services start postgresql@18
brew services start mariadb # use sudo mysql -uroot to create a normal user with permissions
brew services start redis
brew services start memcached

