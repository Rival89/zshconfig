#!/bin/zsh

# Environment variables
#
# XDG Base Directory Specification
# http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html
export XDG_CACHE_HOME="$HOME/.cache"
export ZSH_CONFIG="$XDG_CONFIG_HOME/zsh"
export ZSH_CACHE="$XDG_CACHE_HOME/zsh"
mkdir -p $ZSH_CACHE

# executable search path
export PATH="/bin:$PATH"
export PATH="/usr/share/applications:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/.cargo/bin":$PATH
export PATH="$HOME/.jenv/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/sbin:$PATH"
export PATH="$HOME/.pyenv/bin:$PATH"
export PATH="$HOME/.bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="/snap/bin:$PATH"
export DATE=$(date +%Y-%m-%d)

export TERM=xterm

# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='nano'
 else
   export EDITOR='nvim'
 fi
 
# -U ensures each entry in these is Unique (that is, discards duplicates).
export -U PATH path FPATH fpath MANPATH manpath
export -UT INFOPATH infopath  # -T creates a "tied" pair; see below.

# $PATH and $path (and also $FPATH and $fpath, etc.) are "tied" to each other.
# Modifying one will also modify the other.
# Note that each value in an array is expanded separately. Thus, we can use ~
# for $HOME in each $path entry.
path=(
    $path
    ~/.local/bin
)

if [[ "$(uname)" == "Linux" ]]; then
    path=(/home/linuxbrew/.linuxbrew/bin(N) $path)
fi

# Add your functions to your $fpath, so you can autoload them.
fpath=(
    $ZDOTDIR/functions
    $fpath
    ~/.local/share/zsh/site-functions
)

if command -v brew > /dev/null; then
  eval "$(brew shellenv)"
  fpath+=( $(brew --prefix)/share/zsh/site-functions )
fi

# Colors on GNU ls(1)
if ls --color=auto / >/dev/null 2>&1; then
    ls_options+=( --color=auto )
# Colors on FreeBSD and OSX ls(1)
elif ls -G / >/dev/null 2>&1; then
    ls_options+=( -G )
fi

# Natural sorting order on GNU ls(1)
# OSX and IllumOS have a -v option that is not natural sorting
if ls --version |& grep -q 'GNU' >/dev/null 2>&1 && ls -v / >/dev/null 2>&1; then
    ls_options+=( -v )
fi

# Color on GNU and FreeBSD grep(1)
if grep --color=auto -q "a" <<< "a" >/dev/null 2>&1; then
    grep_options+=( --color=auto )
fi
#Help Functions

 autoload -Uz run-help
(( ${+aliases[run-help]} )) && unalias run-help
alias help=run-help

# Assistant Functions

autoload -Uz run-help-git run-help-ip run-help-openssl run-help-p4 run-help-sudo run-help-svk run-help-svn

# Variables
if [[ "$(uname)" == "Darwin" ]]; then
    export ip=$(ipconfig getifaddr en0)
else
    export ip=$(hostname -I | awk '{print $1}')
fi
