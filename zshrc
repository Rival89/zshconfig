#!/usr/bin/zsh
#
# This file, .zshrc, is sourced by zsh for each interactive shell session.
#

# Enable profiling, if ZSH_PROFILE_RC is set.
[[ -n "$ZSH_PROFILE_RC" ]] && which zmodload >&/dev/null && zmodload zsh/zprof

# Measure boot time.
if command -v gdate >/dev/null 2>&1; then
  bootTimeStart=$(gdate +%s%N)
else
  bootTimeStart=$(date +%s%N)
fi

# Compile zsh scripts.
function zcompile-many() {
  local f
  for f; do zcompile -R -- "$f".zwc "$f"; done
}

# Set watch users.
watch=(notme root)

# Source all .zsh files in rc.d.
() {
  local gitdir=~/.config/zsh/plugins  # Where to keep repos and plugins
  local file=
  for file in $ZDOTDIR/rc.d/<->-*.zsh(n); do
    . $file
  done
} "$@"

# Add functions.d to fpath.
functionsd="$ZSH_CONFIG/functions.d"
if [[ -d "$functionsd" ]] {
    fpath=( $functionsd $fpath )
    autoload -U $functionsd/*(:t)
}

# Autoload all functions in fpath.
for func in $^fpath/*(N-.x:t); autoload -Uz $func

# Set REPORTTIME to 5 seconds.
REPORTTIME=5

# Configure `time` format.
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

# Autoload zsh modules.
autoload -Uz colors zargs zcalc zed zmv

# Enable color support of ls.
if [[ "$(uname)" == "Linux" ]]; then
    export LS_COLORS="$LS_COLORS:ow=30;44:" # fix ls color for folders with 777 permissions
fi

# Set editor.
export EDITOR="nano"

# Set LS_COLORS using vivid.
export LS_COLORS="$(vivid generate dracula)"

# Auto-quote entered URLs.
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

# Edit command line in $EDITOR.
autoload -U edit-command-line
zle -N edit-command-line
bindkey "\ee" edit-command-line  # <Esc-e>

# Do not add a newline before the prompt.
unsetopt PROMPT_SP

# Print stderr with red.
if [[ "$(uname)" == "Linux" ]]; then
    STDERRED_PATH="$HOME/Git/stderred/build/libstderred.so"
    if [ -f $STDERRED_PATH ]; then
        export LD_PRELOAD="${STDERRED_PATH}${LD_PRELOAD:+:$LD_PRELOAD}"
        red_colored_text=$(tput setaf 9)
        export STDERRED_ESC_CODE=`echo -e "$red_colored_text"`
    else
        echo "stderred was not found. Please install it or remove it from .zshrc."
    fi
    unset STDERRED_PATH
fi

# Pyenv configuration.
PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - )"

# Calculate and print boot time.
if command -v gdate >/dev/null 2>&1; then
    bootTimeEnd=$(gdate +%s%N)
else
    bootTimeEnd=$(date +%s%N)
fi
bootTimeDuration=$((($bootTimeEnd - $bootTimeStart)/1000000))
echo "Boot time: $bootTimeDuration ms"
