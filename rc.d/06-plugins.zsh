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


# ZPlug Plugins
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug "ptavares/zsh-direnv"
zplug "b4b4r07/enhancd"
zplug "molovo/revolver", \
  as:command, \
  use:revolver
zplug "lukechilds/zsh-better-npm-completion", defer:2
zplug "lib/completion", from:oh-my-zsh, as:plugin
zplug "plugins/colorize", from:oh-my-zsh, as:plugin
zplug "plugins/gh", from:oh-my-zsh, as:plugin
zplug "plugins/pipenv", from:oh-my-zsh, as:plugin
zplug "plugins/git-extras", from:oh-my-zsh, if:"which git"
zplug "plugins/gnu-utils", from:oh-my-zsh
zplug 'plugins/zsh-256color', from:oh-my-zsh
zplug "plugins/bgnotify", from:oh-my-zsh, as:plugin
zplug "changyuheng/fz", defer:1
zplug "rupa/z", use:z.sh
zplug "darvid/zsh-poetry"
zplug "hlissner/zsh-autopair", defer:2
zplug "z-shell/zsh-lsd"
#zplug "agkozak/agkozak-zsh-prompt"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

## Then, source plugins and add commands to $PATH
zplug load 


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
source <(cod init $$ zsh)
source $ZSH_CONFIG/scripts/chatgpt.zsh
### Dotfile Manager 
### Init Dotfiles + FZF
#source $ZSH_CONFIG/plugins/dotbare/dotbare.plugin.zsh

