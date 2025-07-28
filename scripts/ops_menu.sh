#!/bin/zsh

# Interactive launcher for common ops kit actions
DIR=${0:A:h}
source "$DIR/ops_kit.zsh"

ensure_gum || { echo "gum is required" >&2; exit 1; }

while true; do
  choice=$(printf '%s\n' \
    "Workspace new" \
    "Workspace use" \
    "Start autodiscovery" \
    "Stop autodiscovery" \
    "Run recon wrapper" \
    "Exit" | gum choose --header "Ops Menu")
  case $choice in
    "Workspace new")
      codename=$(gum input --placeholder "codename")
      [[ -n $codename ]] && op:new "$codename"
      ;;
    "Workspace use")
      path=$(gum input --placeholder "path or pattern")
      [[ -n $path ]] && op:use "$path"
      ;;
    "Start autodiscovery")
      gum confirm "Start autodiscovery daemon?" && auto:daemon_start
      ;;
    "Stop autodiscovery")
      auto:daemon_stop
      ;;
    "Run recon wrapper")
      target=$(gum input --placeholder "target host/domain")
      [[ -n $target ]] && "$DIR/recon_wrapper.sh" "$target"
      ;;
    "Exit"|"" ) break ;;
  esac
done
