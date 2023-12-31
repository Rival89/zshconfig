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


function zcompile-many() {
  local f
  for f; do zcompile -R -- "$f".zwc "$f"; done
}

# watch for everyone but me and root
watch=(notme root)


## Introduce environment & prompt files
() {
  local gitdir=~/.config/zsh/plugins  # Where to keep repos and plugins
  local file=
  for file in $ZDOTDIR/rc.d/<->-*.zsh(n); do
    . $file
  done
} "$@"

# add an autoload function path, if directory exists
# http://www.zsh.org/mla/users/2002/msg00232.html
functionsd="$ZSH_CONFIG/functions.d"
if [[ -d "$functionsd" ]] {
    fpath=( $functionsd $fpath )
    autoload -U $functionsd/*(:t)
}

for func in $^fpath/*(N-.x:t); autoload -Uz $func

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
    
    # enable command-not-found if installed
if [ -f /etc/zsh_command_not_found ]; then
    . /etc/zsh_command_not_found
fi
fi


export EDITOR="nano"
export LS_COLORS="$(vivid generate dracula)"

# auto-quote entered URLs
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

# edit command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey "\ee" edit-command-line  # <Esc-e>

 # Do not add a newline before the prompt. 
unsetopt PROMPT_SP

export LD_PRELOAD="/home/rival/Git/stderred/build/libstderred.so${LD_PRELOAD:+:$LD_PRELOAD}"

# Print stderr with red. For more see
# https://github.com/sickill/stderred
STDERRED_PATH="$HOME/Git/stderred/build/libstderred.so"
if [ -f $STDERRED_PATH ]; then
    export LD_PRELOAD="${STDERRED_PATH}${LD_PRELOAD:+:$LD_PRELOAD}"
    red_colored_text=$(tput setaf 9)
    export STDERRED_ESC_CODE=`echo -e "$red_colored_text"`
else
    echo "stderred was not found. Please install it or remove it from .zshrc."
fi
unset STDERRED_PATH

PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - )"

#bindkey -r "^I"
#bindkey "^I" expand-or-complete
#bindkey "^ " fzf-completion

bootTimeEnd=$(gdate +%s%N 2>/dev/null || date +%s%N)
bootTimeDuration=$((($bootTimeEnd - $bootTimeStart)/1000000))
echo $bootTimeDuration ms overall boot duration

export PATH="$HOME/.basher/bin:$PATH"   ##basher5ea843
eval "$(basher init - zsh)"             ##basher5ea843
