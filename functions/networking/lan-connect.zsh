lan-connect() {
  remote="$(lan-scan)"
  echo "username [leave empty if $USER]: "
  read username
  [[ -z "$username" ]] && username=$USER
  ssh $username@$remote
}
