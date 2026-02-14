#!/bin/sh
#
# ~/.bash_aliases
#

alias ll='ls -alhvFA --color=auto --group-directories-first'
alias ls='ls --color=auto'

alias e=$EDITOR
alias v=$VISUAL

alias fcd='cd $(fd --type directory | fzf)'

alias julia='julia --project=@.'

# Dealing with dotfiles.
alias dots='/usr/bin/git --git-dir=$HOME/.dots/ --work-tree=$HOME'
alias lazydots='/usr/bin/lazygit --git-dir=$HOME/.dots/ --work-tree=$HOME'

# Shell bookmark navigation.
if [ -x "$(command -v cdg-path-handler)" ]; then
  alias cdg='cd $(cdg-path-handler)'
fi

export BMFILE="$XDG_DATA_HOME/cdgpaths"
if [ -r $BMFILE ]; then
  alias cdgnv='nvim "$BMFILE"'
fi

# Vim aliases
alias vim='vim --servername vimd'

# Nvim shortcuts.
if [ -x "$(command -v nvim)" ]; then
  alias vi='nvim'
  alias nv='nvim'
fi

# Conda and mamba shortcuts.
if [ -x "$(command -v conda)" ]; then
  alias conda_ub='conda update conda python -y'
  alias conda_all='conda update --all -y'
fi

if [ -x "$(command -v mamba)" ]; then
  alias mamba_ub='mamba update conda mamba python -y'
  alias mamba_all='mamba update --all -y'
fi

# Dropbox shortcuts.
export DBOX=$HOME/Dropbox
if [ -d "$DBOX" ]; then
  alias cdbib='cd "$DBOX/bib"'
  alias res='cd "$DBOX/research/"'
fi
