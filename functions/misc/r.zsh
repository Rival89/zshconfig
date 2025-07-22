# reloads all functions
# http://www.zsh.org/mla/users/2002/msg00232.html
r() {
    local f
    f=(~/.config/zsh/functions.d/*(.))
    unfunction $f:t 2> /dev/null
    autoload -U $f:t
}
