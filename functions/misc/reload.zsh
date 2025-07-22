reload() {
  local f
  f=(/usr/local/share/zsh/site-functions/*(.))
  unfunction $f:t 2> /dev/null
  autoload -U $f:t
}
