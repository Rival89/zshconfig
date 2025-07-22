vm-tunnel() {
  machine="$(VBoxManage list vms | fzf | awk '{gsub(/"/, "", $1); print $1}')"
  ip="$(VBoxManage guestproperty enumerate $machine | grep IP | grep-ip | head -n1)"
  abduco -n vm-tun ssh $1@$ip -D 1337 -C -q -N -v
}
