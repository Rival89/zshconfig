#!/usr/bin/env bash
set -euo pipefail

# --- Helper Functions ---------------------------------------------------------
info() { printf "\033[1;34m[INFO]\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m[WARN]\033[0m %s\n" "$*"; }
fail() { printf "\033[1;31m[FAIL]\033[0m %s\n" "$*"; exit 1; }

# --- Pre-flight Checks --------------------------------------------------------
info "Running pre-flight checks..."

# Check for Zsh
if ! command -v zsh >/dev/null 2>&1; then
  fail "Zsh is not installed. Please install it first and then re-run this script."
fi

# Determine package manager
PM=""
if command -v brew >/dev/null 2>&1; then
  PM="brew"
elif command -v apt-get >/dev/null 2>&1; then
  PM="apt"
else
  warn "No supported package manager (brew/apt) found. Please install dependencies manually."
fi

# --- Dependency Installation --------------------------------------------------
if [[ -n "$PM" ]]; then
  info "Installing dependencies using $PM..."

  # Core dependencies with package names adjusted for the OS
  declare -a BREW_PKGS=("fzf" "starship" "thefuck" "exa" "bat" "lsd" "ripgrep" "fd" "gum")
  declare -a APT_PKGS=("fzf" "starship" "thefuck" "exa" "batcat" "lsd" "ripgrep" "fd-find" "gum")

  if [[ "$PM" == "brew" ]]; then
    for pkg in "${BREW_PKGS[@]}"; do
      if ! brew list "$pkg" >/dev/null 2>&1; then
        info "Installing $pkg..."
        brew install "$pkg"
      else
        info "$pkg is already installed."
      fi
    done
  elif [[ "$PM" == "apt" ]]; then
    info "Updating APT package list..."
    sudo apt-get update -qq
    for pkg in "${APT_PKGS[@]}"; do
      if ! dpkg -l | grep -q "ii  $pkg "; then
        info "Installing $pkg..."
        sudo apt-get install -y -qq "$pkg"
      else
        info "$pkg is already installed."
      fi
    done
    # On Debian/Ubuntu, the 'bat' binary is named 'batcat'
    # We create a symlink to 'bat' if it doesn't exist
    if command -v batcat >/dev/null 2>&1 && ! command -v bat >/dev/null 2>&1; then
        info "Creating symlink for 'bat' from 'batcat'..."
        sudo ln -s /usr/bin/batcat /usr/local/bin/bat
    fi
  fi
else
  warn "Skipping dependency installation. Please ensure the following are installed:
    fzf, starship, thefuck, exa, bat, lsd, ripgrep, fd, gum"
fi

# --- Starship Prompt Configuration -------------------------------------------
info "Configuring Starship prompt..."
STARSHIP_CONFIG_DIR="$HOME/.config"
STARSHIP_CONFIG_FILE="$STARSHIP_CONFIG_DIR/starship.toml"
# Assuming the script is run from the repo root
REPO_STARSHIP_CONFIG="$PWD/starship.toml"

if [[ -f "$REPO_STARSHIP_CONFIG" ]]; then
  mkdir -p "$STARSHIP_CONFIG_DIR"
  if [[ -L "$STARSHIP_CONFIG_FILE" && "$(readlink "$STARSHIP_CONFIG_FILE")" == "$REPO_STARSHIP_CONFIG" ]]; then
    info "Starship config is already linked."
  elif [[ -f "$STARSHIP_CONFIG_FILE" && ! -L "$STARSHIP_CONFIG_FILE" ]]; then
    warn "Found existing starship.toml at $STARSHIP_CONFIG_FILE. Backing it up to ${STARSHIP_CONFIG_FILE}.bak"
    mv "$STARSHIP_CONFIG_FILE" "${STARSHIP_CONFIG_FILE}.bak"
    ln -s "$REPO_STARSHIP_CONFIG" "$STARSHIP_CONFIG_FILE"
    info "Created symlink for starship.toml."
  elif [[ ! -e "$STARSHIP_CONFIG_FILE" ]]; then
    ln -s "$REPO_STARSHIP_CONFIG" "$STARSHIP_CONFIG_FILE"
    info "Created symlink for starship.toml."
  fi
else
  warn "starship.toml not found in repository. Skipping prompt configuration."
fi

# --- Zinit Installation -------------------------------------------------------
info "Checking Zinit installation..."
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
  info "Installing zinit..."
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
else
  info "Zinit is already installed."
fi

# --- Final Steps --------------------------------------------------------------
info "Bootstrap complete! Please restart your shell for all changes to take effect."
