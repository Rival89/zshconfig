function pip-search() {
  # 'pip search' is gone; try: pip install pip_search
  if ! (( $+commands[pip_search] )); then echo "pip_search not found (Try: pip install pip_search)."; return 1; fi
  if [[ -z "$1" ]]; then echo "argument required"; return 1; fi
  pip-search "$@" | fzf --reverse --multi --no-sort --header-lines=4 | awk '{print $3}'
}
