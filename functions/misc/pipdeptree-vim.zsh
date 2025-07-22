function pipdeptree-vim() {   # e.g. pipdeptree -p <package>
  python -m pipdeptree "$@" | vim - +"set ft=config foldmethod=indent" +"norm zR"
}
