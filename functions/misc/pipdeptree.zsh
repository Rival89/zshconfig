function pipdeptree() {
  python -m pipdeptree "$@" | fzf --reverse
}
