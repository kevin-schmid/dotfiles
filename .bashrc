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

# mise activate
eval "$(/home/kevin/.local/bin/mise activate bash)"

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

alias g='git'
alias ga='git add'
alias gb='git checkout -b'
alias gc='git commit -m'
alias gd='git diff --minimal --color-moved=plain'
alias gds='git diff --minimal --color-moved=plain --staged'
alias gl="git log --graph --pretty=format:'%Cred%h %Cgreen%cs %Cblue%an%Creset:%C(yellow)%d%Creset %s %Creset' --abbrev-commit"
alias gm='git checkout main'
alias gp='git pull'
alias gs='git status'
alias gu='git push'
