#!/usr/bin/env bash
# .bash_aliases

alias ll='ls -alhvFA --color=auto --group-directories-first'
alias ls='ls --color=auto'

alias e=$EDITOR
alias v=$VISUAL

alias fcd='cd $(fd --type directory | fzf)'

alias julia='julia --project=@.'

# Dealing with dotfiles.
export DOTSDIR=$HOME/dotfiles
if [ -d "$DOTSDIR" ]; then
    alias cddots='cd $DOTSDIR'
fi

# Shell bookmark navigation.
if [ -x "$(command -v cdg-path-handler)" ]; then
    alias cdg='cd $(cdg-path-handler)'
fi

export BMFILE="$XDG_DATA_HOME/cdgpaths"
if [ -r $BMFILE ]; then
    alias cdgnv='nvim "$BMFILE"'
fi

# Vim aliases
# TODO: Might be worth making this conditional on Fedora.
alias vim='vimx --servername vimd'

# Nvim shortcuts.
if [ -x "$(command -v nvim)" ]; then
    alias vi='nvim'
    alias nv='nvim'
fi

# Dropbox shortcuts.
export DBOX=$HOME/Dropbox
if [ -d "$DBOX" ]; then
    alias cdbib='cd "$DBOX/bib/"'
    alias cdpdf='cd "$DBOX/bib/pdf/"'
    alias res='cd "$DBOX/research/"'
fi
