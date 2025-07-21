#!/bin/zsh
# Plugins
#
# Autocomplete automatically selects a backend for its recent dirs completions.
# So, normally you won't need to change this.
# However, you can set it if you find that the wrong backend is being used.
zstyle ':autocomplete:recent-dirs' fasd
# cdr:  Use Zsh's `cdr` function to show recent directories as completions.
# no:   Don't show recent directories.
# zsh-z|zoxide|z.lua|z.sh|autojump|fasd: Use this instead (if installed).
# ⚠️ NOTE: This setting can NOT be changed at runtime.

zstyle ':autocomplete:*' widget-style menu-select
# complete-word: (Shift-)Tab inserts the top (bottom) completion.
# menu-complete: Press again to cycle to next (previous) completion.
# menu-select:   Same as `menu-complete`, but updates selection in menu.
# ⚠️ NOTE: This setting can NOT be changed at runtime.

# The Zsh Autocomplete plugin sends *a lot* of characters to your terminal.
# This is fine locally on modern machines, but if you're working through a slow
# ssh connection, you might want to add a slight delay before the
# autocompletion kicks in:
   zstyle ':autocomplete:*' min-delay 0.5  # seconds
#
# If your connection is VERY slow, then you might want to disable
# autocompletion completely and use only tab completion instead:
   zstyle ':autocomplete:*' async yes


#ZSH Unplugged
# make list of the Zsh plugins you use
repos=(
  # plugins that you want loaded first
  marlonrichert/zsh-autocomplete		# Real-time type-ahead completion
  djui/alias-tips
  supercrabtree/k
  fzf-tab
  command-not-found
  common-aliases
  colored-man-pages
  debian
  fasd
  zshzoo/magic-enter
  npm
  postgres
  python
  sudo
  systemd
  thefuck
  web-search
#  # other pluginsz
  romkatv/zsh-defer
  pip
  fzf
  grc
  zsh-interactive-cd
  virtualenv
  virtualenvwrapper
  nmap
  zoxide
# plugins you want loaded last  
  marlonrichert/zsh-edit              # Better keyboard shortcuts
  marlonrichert/zsh-hist              # Edit history from the command line.
  marlonrichert/zcolors               # Colors for completions and Git
  zsh-users/zsh-completions
  zsh-users/zsh-syntax-highlighting		# Command-line syntax highlighting
#  zdharma-continuum/fast-syntax-highlighting
  history-substring-search
  zsh-users/zsh-autosuggestions		# Inline suggestions
  MichaelAquilina/zsh-autoswitch-virtualenv
)

# now load your plugins
plugin-load $repos


eval "$(fasd --init auto)"
if command -v cod > /dev/null; then
    source <(cod init $$ zsh)
fi
if [[ -f "$ZSH_CONFIG/scripts/chatgpt.zsh" ]]; then
    source $ZSH_CONFIG/scripts/chatgpt.zsh
fi
