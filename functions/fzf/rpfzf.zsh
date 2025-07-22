#Display running processes in FZF

function rpfzf() {
  local pid
  pid=$(ps aux --sort=-%cpu | sed -e '1d' | fzf --reverse -m | awk '{print $2}')

  if [[ -n $pid ]]; then
    echo "Selected process ID(s): $pid"
    read -q "REPLY?Kill selected process(es)? (y/n) "
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      echo "Killing process(es)..."
      echo $pid | xargs kill
    fi
  fi
}
