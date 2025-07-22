vm-connect() {
  machine="$(VBoxManage list vms | fzf | awk '{gsub(/"/, "", $1); print $1}')"
  ip="$(VBoxManage guestproperty enumerate $machine | grep IP | grep-ip | head -n1)"
  if [ -z "$1" ]; then
    ssh $USER@$ip
  else
    ssh $1@$ip
  fi
}
