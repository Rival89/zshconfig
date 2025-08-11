#!/usr/bin/zsh
#
# This file, .zshrc, is sourced by zsh for each interactive shell session.
#
# Note: For historical reasons, there are other dotfiles, besides .zshenv and
# .zshrc, that zsh reads, but there is really no need to use those.

# }}}
# {{{ Profiling

[[ -n "$ZSH_PROFILE_RC" ]] && which zmodload >&/dev/null && zmodload zsh/zprof

 #take tike to measure boot time
bootTimeStart=$(gdate +%s%N 2>/dev/null || date +%s%N)


## Introduce environment & prompt files
() {
  local file=
  for file in $ZDOTDIR/rc.d/<->-*.zsh(n); do
    . $file
  done
} "$@"

# add an autoload function path, if directory exists
# http://www.zsh.org/mla/users/2002/msg00232.html
functionsd="$ZSH_CONFIG/functions.d"
if [[ -d "$functionsd" ]]; then
    fpath=( "$functionsd" $fpath )
    autoload -U "$functionsd"/*(:t)
fi

#for func in $^fpath/*(N-.x:t); autoload -Uz $func

# Show time/memory for commands running longer than this number of seconds:
REPORTTIME=5

# configure `time` format
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

# We want zmv and other nice features (man zshcontrib)
autoload -Uz colors zargs zcalc zed zmv

# enable color support of ls, less and man, and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    export LS_COLORS="$LS_COLORS:ow=30;44:" # fix ls color for folders with 777 permissions
fi


export EDITOR="nano"

# Auto-quote URLs pasted into the command line.
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

# Edit the current command line in $EDITOR.
autoload -U edit-command-line
zle -N edit-command-line
bindkey "\ee" edit-command-line  # <Esc-e>

# Do not add a newline before the prompt.
unsetopt PROMPT_SP

# Guard against missing commands
if command -v vivid >/dev/null 2>&1; then
  cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}"
  mkdir -p "$cache_dir"
  ls_cache="$cache_dir/ls_colors"
  if [[ ! -r "$ls_cache" ]]; then
    vivid generate dracula >| "$ls_cache"
  fi
  export LS_COLORS="$(<"$ls_cache")"
fi

case "$OSTYPE" in
  darwin*)
    PLATFORM="macos"
    # Use GNU coreutils if available
    command -v gdate >/dev/null 2>&1 && alias date="gdate"
    ;;
  linux*)
    if grep -qi microsoft /proc/version 2>/dev/null || [[ -n "$WSL_DISTRO_NAME" ]]; then
      PLATFORM="wsl"
    else
      PLATFORM="linux"
    fi
    if [[ -r "$HOME/Git/stderred/build/libstderred.so" ]]; then
      export LD_PRELOAD="$HOME/Git/stderred/build/libstderred.so:${LD_PRELOAD:-}"
    fi
    ;;
  cygwin*|msys*|win32*)
    PLATFORM="windows"
    ;;
  *)
    PLATFORM="unknown"
    ;;
esac
export PLATFORM

if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

if command -v basher >/dev/null 2>&1; then
  eval "$(basher init - zsh)"
fi

if command -v thefuck >/dev/null 2>&1; then
  eval "$(thefuck --alias)"
fi

bootTimeEnd=$(gdate +%s%N 2>/dev/null || date +%s%N)
bootTimeDuration=$((($bootTimeEnd - $bootTimeStart)/1000000))
echo $bootTimeDuration ms overall boot duration
