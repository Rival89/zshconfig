function conda-list() {
  conda list "$@" | fzf --header-lines 3 --reverse --nth 1 --multi | awk '{print $1}'
}
