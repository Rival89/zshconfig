#!/bin/zsh

autoload -Uz promptinit
promptinit
export STARSHIP_CONFIG=~/.config/starship/starship.toml
function set_win_title(){
    echo -ne "\033]0; $(basename "$PWD") \007"
}
starship_precmd_user_func="set_win_title"

eval "$(starship init zsh)"
