#!/usr/bin/zsh
#
# This file, .zshenv, is the first file sourced by zsh for EACH shell, whether
# it's interactive or not.
#

# Allow disabling of entire environment suite
[ -n "$INHERIT_ENV" ] && return 0

# Stop bad system-wide scripts interfering.
setopt NO_global_rcs 

# Set ZDOTDIR to ~/.config/zsh.
ZDOTDIR=${XDG_CONFIG_HOME:=~/.config}/zsh
ZSH_CACHE_DIR=~/.cache/zsh

# Set umask.
umask 022

# Skip the not really helpful Ubuntu global compinit.
skip_global_compinit=1
shell=zsh

# Set zdotdir.
zdotdir=${ZDOTDIR:-$HOME}
export ZDOTDIR="$zdotdir"

# Use extended globbing.
setopt extended_glob

# Prevent duplicates in path variables.
typeset -U path
typeset -U manpath
export MANPATH

typeset -TU LD_LIBRARY_PATH ld_library_path
typeset -TU PERL5LIB perl5lib

# Ruby libraries.
typeset -TU RUBYLIB rubylib
export RUBYLIB
rubylib=( 
          ~/lib/[r]uby{/site_ruby,}{/1.*,}{/i?86*,}(N)
          ~/lib/[r]uby(N)
          $rubylib
         )

# Python libraries.
typeset -TU PYTHONPATH pythonpath
export PYTHONPATH

# fpath/autoloads
typeset -U fpath
fpath=(
       {~,$zdotdir}/.[z]sh/$ZSH_VERSION/*.zwc(N)
       {~,$zdotdir}/{.[z]sh,[l]ib/zsh}/{functions{,/person-$ZDOTUSER,/host-${HOST%%.*}},scripts}(N)
       /etc/zsh_completion.d
       $fpath
)

# Establish Path.
if [[ -z "$PATH" || "$PATH" == "/bin:/usr/bin" ]]
then
	export PATH="/usr/local/bin:/usr/bin:/bin:/usr/games"
fi

# Add user's private bin to PATH.
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# Add user's local bin to PATH.
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Add user's cargo bin to PATH.
if [ -d "$HOME/.cargo/bin" ] ; then
    PATH="$HOME/.cargo/bin:$PATH"
fi

# Source cargo env.
. "$HOME/.cargo/env"
