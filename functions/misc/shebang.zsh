# create a new script, automatically populating the shebang line, editing the
# script, and making it executable.
shebang() {
  if [[ -z $1 ]]; then
    echo "Please provide a script name."
    return
  fi

  local script_name=$1
  shift
  local add_to_path=false

  if [[ $1 == '-p' ]]; then
    add_to_path=true
    shift
  fi

  cat > $script_name <<EOF
#! /bin/zsh

$*
EOF

  chmod +x $script_name

  echo "New executable zsh script created: $script_name"

  if $add_to_path; then
    echo "Adding $script_name to PATH..."
    echo 'export PATH="$PATH:$(dirname $script_name)"' >> ~/.zshrc
    source ~/.zshrc
    echo "$script_name added to PATH!"
  fi
}
