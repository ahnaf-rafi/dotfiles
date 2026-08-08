#!/usr/bin/env bash
# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Enable fzf keybindings and fuzzy completion.
eval "$(fzf --bash)"

# Alias definitions in ~/.bash_aliases.
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

export PAGER=less
export MANPAGER='nvim +Man!'
export EDITOR=nvim
export VISUAL=nvim

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
