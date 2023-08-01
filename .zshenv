#!/usr/bin/zsh
#
# This file, .zshenv, is the first file sourced by zsh for EACH shell, whether
# it's interactive or not.
# This includes non-interactive sub-shells!
# So, put as little in this file as possible, to avoid performance impact.
#

# Note: The shebang #!/bin/zsh is strictly necessary for executable scripts
# only, but without it, you might not always get correct syntax highlighting
# when viewing the code.

# Tell zsh where to look for our dotfiles.
# By default, Zsh will look for dotfiles in $HOME (and find this file), but
# once $ZDOTDIR is defined, it will start looking in that dir instead.
# ${X:=Y} specifies a default value Y to use for parameter X, if X has not been
# set or is null. This will actually create X, if necessary, and assign the
# value to it.
# To set a default value that is returned *without* setting X, use ${X:-Y}
# As in other shells, ~ expands to $HOME _at the beginning of a value only._

# Allow disabling of entire environment suite
[ -n "$INHERIT_ENV" ] && return 0

# Stop bad system-wide scripts interfering.
setopt NO_global_rcs 

ZDOTDIR=${XDG_CONFIG_HOME:=~/.config}/zsh
ZSH_CACHE_DIR=~/.cache/zsh
# Global Order: zshenv, zprofile, zshrc, zlogin

umask 022

# Skip the not really helpful Ubuntu global compinit
skip_global_compinit=1
shell=zsh

# ZDOTDIR is a zsh-ism but it's a good concept so we generalize it to
# the other shells.
zdotdir=${ZDOTDIR:-$HOME}
export ZDOTDIR="$zdotdir"

## }}}

#[[ -e $zdotdir/.shared_env ]] && . $zdotdir/.shared_env


setopt extended_glob

# {{{ prevent duplicates in path variables

# path and manpath are special - "hardcoded" tie with $(MAN)PATH
typeset -U path
typeset -U manpath
export MANPATH

typeset -TU LD_LIBRARY_PATH ld_library_path
typeset -TU PERL5LIB perl5lib

# }}}
# {{{ Ruby libraries

typeset -TU RUBYLIB rubylib
export RUBYLIB
rubylib=( 
          ~/lib/[r]uby{/site_ruby,}{/1.*,}{/i?86*,}(N)
          ~/lib/[r]uby(N)
          $rubylib
         )

# }}}
# {{{ Python libraries

typeset -TU PYTHONPATH pythonpath
export PYTHONPATH

# }}}

# {{{ fpath/autoloads



typeset -U fpath
fpath=(
       {~,$zdotdir}/.[z]sh/$ZSH_VERSION/*.zwc(N)
       {~,$zdotdir}/{.[z]sh,[l]ib/zsh}/{functions{,/person-$ZDOTUSER,/host-${HOST%%.*}},scripts}(N)
       /etc/zsh_completion.d
       $fpath
)

# Autoload shell functions from all directories in $fpath.  Restrict
# functions from $zdotdir/.zsh to ones that have the executable bit
# on.  (The executable bit is not necessary, but gives you an easy way
# to stop the autoloading of a particular shell function).
#
# The ':t' is a history modifier to produce the tail of the file only,
# i.e. dropping the directory path.  The 'x' glob qualifier means
# executable by the owner (which might not be the same as the current
# user).

#for dirname in $fpath; do
#  case "$dirname" in
#    $zdotdir/.zsh*) fns=( $dirname/*~*~(-N.x:t) ) ;;
#                 *) fns=( $dirname/*~*~(-N.:t)  ) ;;
#  esac
#  (( $#fns )) && autoload "$fns[@]"
#done

# }}}

# {{{ Specific to hosts

#run_hooks .zshenv.d

# }}}
# Establish Path
if [[ -z "$PATH" || "$PATH" == "/bin:/usr/bin" ]]
then
	export PATH="/usr/local/bin:/usr/bin:/bin:/usr/games"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# set PATH so it includes user's cargo bin if it exists
if [ -d "$HOME/.cargo/bin" ] ; then
    PATH="$HOME/.cargo/bin:$PATH"
fi


. "$HOME/.cargo/env"
