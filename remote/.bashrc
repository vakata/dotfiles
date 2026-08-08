# Do nothing for non-interactive shells.
case $- in
    *i*) ;;
      *) return ;;
esac

# History.
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth:erasedups
shopt -s histappend

# Append history after every command instead of only on shell exit.
PROMPT_COMMAND='history -a; history -n'

# Useful shell behavior.
shopt -s checkwinsize
shopt -s globstar 2>/dev/null

# Colors where supported.
if command -v dircolors >/dev/null 2>&1; then
    eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi

alias ll='ls -lah'
alias la='ls -A'
alias l='ls -alhF'
alias ..='cd ..'
alias ...='cd ../..'
alias ta='tmux new -A -s main'
alias c='clear'
alias v='vim'

# Simple prompt:
# PS1='\u@\h:\w\$ '
PS1='\[\e[32m\]\u@\h\[\e[0m\]:\[\e[34m\]\w\[\e[0m\]\$ '

# Vim as editor when available.
if command -v vim >/dev/null 2>&1; then
    export EDITOR=vim
    export VISUAL=vim
fi
