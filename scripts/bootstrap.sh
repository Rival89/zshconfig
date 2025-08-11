#!/usr/bin/env bash
set -euo pipefail

install_pkg() {
  if command -v brew >/dev/null 2>&1; then
    brew install "$@"
  elif command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update && sudo apt-get install -y "$@"
  else
    echo "No supported package manager found" >&2
    return 1
  fi
}

# Zinit
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Starship prompt
command -v starship >/dev/null 2>&1 || install_pkg starship

# Thefuck command corrector
command -v thefuck >/dev/null 2>&1 || install_pkg thefuck
