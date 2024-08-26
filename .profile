# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
if [ -d "$HOME/.local/bin/go/bin" ] ; then
    PATH="$HOME/.local/bin/go/bin:$PATH"
fi

export PATH=$PATH:/var/lib/flatpak/exports/bin/

export TIME_STYLE=long-iso
export XKB_DEFAULT_LAYOUT=de,us
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

# respect XDG
mkdir "$XDG_DATA_HOME/bash"
export HISTFILE="$XDG_DATA_HOME/bash/history"
mkdir "$XDG_DATA_HOME/less"
export LESSHISTFILE="$XDG_DATA_HOME/less/history"
export GNUPGHOME=$XDG_CONFIG_HOME/gnupg/
export KUBECONFIG=$XDG_CONFIG_HOME/kube/config
export KUBECACHEDIR=$XDG_CACHE_HOME/kube
export npm_config_userconfig=$XDG_CONFIG_HOME/npm/config
export npm_config_cache=$XDG_CACHE_HOME/npm
export AZURE_CONFIG_DIR=$XDG_CONFIG_HOME/azure
export GOPATH=$XDG_DATA_HOME/go
export TF_CLI_CONFIG_FILE=$XDG_CONFIG_HOME/terraform/config.tfrc
export XAUTHORITY=$XDG_RUNTIME_DIR/Xauthority
export XINITRC=$XDG_CONFIG_HOME/X11/xinitrc
export XSERVERRC=$XDG_CONFIG_HOME/X11/xserverrc

if [ "${XDG_VTNR}" -eq 1 ]; then
    # choose window manager
    echo "i) i3"
    echo "e) exit"
    echo "*) sway (default)"

    read -p "Choose window manager: " choice
    case $choice in
        'i')
            export XDG_SESSION_TYPE=x11
            exec startx
            ;;
        'e')
            exec exit
            ;;
        *)
            export XDG_SESSION_TYPE=wayland
            exec sway
            ;;
    esac
fi
# if [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
#   exec sway
# fi
