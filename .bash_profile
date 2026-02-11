#!/bin/sh
#
# ~/.bash_profile
#

# Enable fzf keybindings and fuzzy completion.
eval "$(fzf --bash)"

# Set PATH
export PATH=$HOME/.local/bin:$HOME/bin:$PATH

export H=$HOME
export XDG_CURRENT_DESKTOP=sway
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

export TERMINAL=/usr/bin/kitty
export TERMCMD=/usr/bin/kitty
export BROWSER=/usr/bin/google-chrome-stable
export PAGER=/usr/bin/less
export MANPAGER='/usr/bin/nvim +Man!'

export EDITOR=/usr/bin/nvim
export VISUAL=/usr/bin/nvim

# Options for FZF
export FZF_DEFAULT_COMMAND='fd -t f -H -L -E .dots -E .git'
export FZF_DEFAULT_OPTS='-m --bind ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle-all'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd -t d -H -L -E .dots -E .git'

# R environment
if [ -d $XDG_CONFIG_HOME/R ] ; then
  export R_ENVIRON_USER="$XDG_CONFIG_HOME/R/Renviron"
  export R_PROFILE_USER="$XDG_CONFIG_HOME/R/Rprofile"
fi

[[ -f ~/.bashrc ]] && . ~/.bashrc

if [ -z "$WAYLAND_DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ] ; then
  exec sway
fi

# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

case ":$PATH:" in
    *:/home/ahnafrafi/.juliaup/bin:*)
        ;;

    *)
        export PATH=/home/ahnafrafi/.juliaup/bin${PATH:+:${PATH}}
        ;;
esac

# <<< juliaup initialize <<<
