# exports
export ZSH="$HOME/.oh-my-zsh"
export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git --color=always'
export FZF_CTRL_T_COMMAND=
export FZF_DEFAULT_OPTS="--ansi"
export IBM_DB_HOME=$HOME/db2/clidriver
export ORACLE_HOME=$HOME/instantclient
export PATH=$ORACLE_HOME:$IBM_DB_HOME:/opt/oracle/instantclient:/opt/homebrew/bin:$HOME/bin:/usr/local/bin:$PATH
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE="UTF-8"
export DYLD_LIBRARY_PATH=$HOME/db2/lib:$HOME/instantclient:$DYLD_LIBRARY_PATH
export OCI_LIB_DIR=$HOME/instantclient
export OCI_INC_DIR=$HOME/instantclient/sdk/include
export EDITOR='nvim'
export VISUAL='nvim'
export GIT_EDITOR='nvim'

# source all
ZSH_THEME="powerlevel10k/powerlevel10k"
zstyle :omz:plugins:ssh-agent agent-forwarding yes
zstyle :omz:plugins:ssh-agent ssh-add-args --apple-load-keychain
zstyle :omz:plugins:ssh-agent quiet yes
zstyle :omz:plugins:ssh-agent lazy yes
#plugins=(colored-man-pages colorize ssh ssh-agent zsh-autosuggestions zsh-syntax-highlighting zsh-vi-mode)
plugins=(colored-man-pages colorize ssh ssh-agent zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.zshrc.private ] && source ~/.zshrc.private
[ -f ~/.p10k.zsh ] && source ~/.p10k.zsh

# vi mode
# ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLOCK
# ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_UNDERLINE
# ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
# function zvm_after_init() {
#   [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# }

# options and binds
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
bindkey "^[[1;3D" backward-word
bindkey "^[[1;3C" forward-word
bindkey  "^[[D"   beginning-of-line
bindkey  "^[[C"   end-of-line

# aliases
alias fu="sudo !!"
alias y="yazi"
alias bu="brew update && brew upgrade && brew upgrade --cask --greedy && brew cleanup"
alias vpn="~/scripts/vpn.sh"
alias g="lazygit"
alias gp='git pushall ; git pushalltags'
alias gpo='git pull origin'
alias ta='tmux new -As default'
alias fz='fzf --preview="bat --color=always {}"'
alias vzf='nvim $(fzf -m --preview="bat --color=always {}")'
alias v='nvim'
alias ll='ls -alF'
alias la='ls -A'
alias l='eza -a --long --color=always --git --icons --group --time-style=long-iso --group-directories-first'
alias lt='eza -a --long --color=always --git --icons --group --time-style=long-iso --group-directories-first --tree'
alias c='clear'
o() {
    open sftp://$1
}
zp() {
    zip -r "${2:-$1}".zip "$1" -x "*.DS_Store" -x "*.git*" -x "*.svn*";
}
tunnel() {
    ssh -ND 9999 $1
}
cmpr() {
    if (( $# != 2 )); then
        print -u2 "Usage: cmpr DIR1 DIR2"
        return 2
    fi

    git diff \
        --no-index \
        --no-color \
        --src-prefix="a/" \
        --dst-prefix="b/" \
        -- "$1" "$2" |
        hunk patch -

    local git_status=$pipestatus[1]
    (( git_status <= 1 ))
}
compdef _hosts o
compdef _hosts tunnel

eval "$(zoxide init zsh)"

