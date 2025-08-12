#!/bin/zsh

# Shortcut for lazygit
alias lg="lazygit"

# Clone a repository and cd into it
alias gfcd='gfcd() { git clone "$1" && cd "$(basename "$1" .git)"; }; gfcd'

# Manage dotfiles using a bare git repository
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
# Simple git clone
alias gfc="git clone"
