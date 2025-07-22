vm-start() {
  machine="$(VBoxManage list vms | fzf | awk '{gsub(/"/, "", $1); print $1}')"
  VBoxManage startvm $machine --type headless
}
