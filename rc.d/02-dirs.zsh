#!/bin/zsh
# Named directories
#
# Set these early, because it affects how dirs are displayed and printed.
#

# Create shortcuts for your favorite directories.
# `hash -d <name>=<path>` makes ~<name> a shortcut for <path>.
# You can use this ~name anywhere you would specify a dir, not just with `cd`!
hash -d z=$ZDOTDIR
hash -d g=$gitdir


# Change dirs without `cd`. Just type the dir and press enter.
# NOTE: This will misfire if there is an alias, function, builtin or command
# with the same name!
# To be safe, use autocd only with paths starting with .. or / or ~ (including
# named directories).
setopt AUTO_CD
# 3.2. Changing Directories
# -------------------------
setopt autocd               # automatically cd to a directory if not cmd
setopt autopushd            # automatically pushd directories on dirstack
setopt nopushdsilent        # print dirstack after each cd/pushd
setopt pushdignoredups      # don't push dups on stack
setopt pushdminus           # pushd -N goes to Nth dir in stack
export DIRSTACKSIZE=8

setopt autonamedirs             # % export h=/home/sjs; cd ~h; pwd => /home/sjs
setopt cdablevars               # blah=~/media/movies; cd blah; pwd => ~/media/movies


export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Search path for the cd command
cdpath=(.. ~ ~/src ~/.config/zsh ~/Git)


# Where to look for autoloaded function definitions
fpath=($fpath ~/.config/zsh/functions)


# Use hard limits, except for a smaller stack and no core dumps
if command -v unlimit >/dev/null 2>&1; then
    unlimit
    limit stack 8192
    limit core 0
    limit -s
fi
