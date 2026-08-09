# exports
export ZSH="$HOME/.oh-my-zsh"
export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git --color=always'
export FZF_CTRL_T_COMMAND=
export FZF_DEFAULT_OPTS="--ansi"
export PATH=$HOME/bin:/usr/local/bin:$PATH
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE="UTF-8"
export EDITOR='nvim'
export VISUAL='nvim'
export GIT_EDITOR='vim'
if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# completion
autoload -Uz compinit
compinit

# source all
#ZSH_THEME="powerlevel10k/powerlevel10k"
#zstyle :omz:plugins:ssh-agent agent-forwarding yes
#zstyle :omz:plugins:ssh-agent ssh-add-args --apple-load-keychain
#zstyle :omz:plugins:ssh-agent quiet yes
#zstyle :omz:plugins:ssh-agent lazy yes
#plugins=(colored-man-pages colorize ssh ssh-agent zsh-autosuggestions zsh-syntax-highlighting)
#source $ZSH/oh-my-zsh.sh
[ -f ~/.zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme ] && source ~/.zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme
[ -f ~/.p10k.zsh ] && source ~/.p10k.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[ -f ~/.zshrc.private ] && source ~/.zshrc.private

# options and binds
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
bindkey -e
bindkey "^[[1;3D" backward-word
bindkey "^[[1;3C" forward-word

# aliases
alias y="yazi"
alias bu="brew update && brew upgrade && brew upgrade --cask --greedy && brew cleanup"
alias vpn="~/scripts/vpn.sh"
alias g="lazygit"
alias gp='git pushall ; git pushalltags'
alias gpo='git pull origin'
alias ta='tmux new -As default'
alias fzf='fzf --preview="bat --color=always {}"'
alias v='nvim'
alias ll='ls -alF'
alias la='ls -A'
alias l='eza -a --long --color=always --git --icons --group --time-style=long-iso --group-directories-first'
alias lt='eza -a --long --color=always --git --icons --group --time-style=long-iso --group-directories-first --tree'
alias c='clear'
o() {
    open "sftp://$1"
}
tunnel() {
    ssh -ND 9999 "$1"
}
compdef _hosts o
compdef _hosts tunnel

eval "$(zoxide init zsh)"

