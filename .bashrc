# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# bash config
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend
shopt -s checkwinsize
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# prompt
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac
PS1='${debian_chroot:+($debian_chroot)}\w > '
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

export GPG_TTY=$(tty)

# enable color support of ls
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# nvm config
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias l='ls -lha'
alias v='nvim'
alias k='kubectl'
alias klear='k delete pod --field-selector=status.phase!=Running'
alias dotfiles='/usr/bin/git --git-dir=$XDG_CONFIG_HOME/dotfiles/ --work-tree=$HOME'
function tf {
    terraform fmt -list=false
    terraform "$@"
}

alias gs='git status'
alias ga='git add'
alias gp='git push'
alias gd='git diff'
alias gds='git diff --staged'
function gc {
    git commit -m "$@"
}
