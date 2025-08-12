#!/bin/zsh

alias lg="lazygit"

# Clone and enter repository
alias gfcd='gfcd() { git clone "$1" && cd "$(basename "$1" .git)"; }; gfcd'

alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
alias gfc="git clone"
