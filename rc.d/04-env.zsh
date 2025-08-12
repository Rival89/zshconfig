#!/bin/zsh

# Environment variables
#
# XDG Base Directory Specification
# http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html
export XDG_CACHE_HOME="$HOME/.cache"
export ZSH_CONFIG="$XDG_CONFIG_HOME/zsh"
export ZSH_CACHE="$XDG_CACHE_HOME/zsh"
#export ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh"
mkdir -p $ZSH_CACHE

# executable search path
typeset -U path
path=(
    /bin(N)
    /usr/share/applications(N)
    /usr/local/sbin(N)
    $HOME/.cargo/bin(N)
    $HOME/.jenv/bin(N)
    $HOME/.rbenv/bin(N)
    $HOME/.local/bin(N)
    $HOME/.local/sbin(N)
    $HOME/.pyenv/bin(N)
    $HOME/.bin(N)
    $HOME/bin(N)
    /snap/bin(N)
    $HOME/profiles/NetworkUnmanger/unmanage_interface(N)
    /home/linuxbrew/.linuxbrew/bin(N)
    $path
)
export PATH
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

# Add your functions to your $fpath, so you can autoload them.
fpath=(
    $ZDOTDIR/functions
    $fpath
    ~/.local/share/zsh/site-functions
)

if command -v brew >/dev/null 2>&1; then
  eval "$(brew shellenv)"
  fpath+=( "$HOMEBREW_PREFIX/share/zsh/site-functions" )
fi

# Options for `ls` command.
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

# Options for `grep` command.
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
## Variables
export ip=$(hostname -I | awk '{print $1}')

