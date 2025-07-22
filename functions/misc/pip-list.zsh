# some useful fzf-grepping functions for python
function pip-list() {
  pip list "$@" | fzf --header-lines 2 --reverse --nth 1 --multi | awk '{print $1}'
}
