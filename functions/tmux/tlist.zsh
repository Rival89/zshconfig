tlist() {
  tmuxinator list | tail -n 1 | awk -v OFS="\n" '$1=$1' | fzf
}
