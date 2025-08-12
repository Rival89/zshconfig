#!/bin/zsh

# Install zinit if needed
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [[ ! -f "$ZINIT_HOME/zinit.zsh" ]]; then
  mkdir -p "${ZINIT_HOME:h}"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME" || {
    echo "Failed to install zinit" >&2
    return 1
  }
fi
source "$ZINIT_HOME/zinit.zsh" || return 1

# Core plugins loaded immediately
zinit light-mode for \
  zsh-users/zsh-autosuggestions \
  zsh-users/zsh-syntax-highlighting \
  zsh-users/zsh-completions \
  zsh-users/zsh-history-substring-search \
  romkatv/zsh-defer

# Plugins loaded lazily after zsh starts
zinit light-mode wait"1" lucid for \
  marlonrichert/zsh-autocomplete \
  marlonrichert/zsh-hist \
  marlonrichert/zcolors \
  Aloxaf/fzf-tab \
  junegunn/fzf \
  supercrabtree/k \
  djui/alias-tips \
  garabik/grc \
  ptavares/zsh-direnv \
  b4b4r07/enhancd \
  molovo/revolver \
  lukechilds/zsh-better-npm-completion \
  darvid/zsh-poetry \
  hlissner/zsh-autopair \
  zoxide/zoxide

# Additional programs
zinit ice wait"1" lucid as"program"
zinit light rupa/z
zinit ice wait"1" lucid as"program"
zinit light changyuheng/fz

# Optional plugins that depend on external tools
if command -v lsd >/dev/null 2>&1; then
  zinit light-mode wait"1" lucid for z-shell/zsh-lsd
fi
if command -v python >/dev/null 2>&1; then
  zinit light-mode wait"1" lucid for MichaelAquilina/zsh-autoswitch-virtualenv
fi

# Log plugin health asynchronously
zinit_plugin_health() {
  local report="${XDG_CACHE_HOME:-$HOME/.cache}/zinit_health.log"
  mkdir -p "${report%/*}"
  command -v zinit >/dev/null 2>&1 || return
  zinit report &>"$report"
}

zinit_plugin_health &!
