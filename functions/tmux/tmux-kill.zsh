# filter & kill active tmux sessions
tmux-kill(){
  tmux list-sessions | awk 'BEGIN{FS=":"}{print $1}' | fzf | xargs -n 1 tmux kill-session -t
}
