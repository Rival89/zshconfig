#!/bin/zsh

# Install zinit
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    mkdir -p "$(dirname "$HOME/.local/share/zinit/zinit.git")"
    git clone https://github.com/zdharma-continuum/zinit.git "$HOME/.local/share/zinit/zinit.git"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

# Load plugins
zinit light "zsh-users/zsh-autosuggestions"
zinit light "zsh-users/zsh-syntax-highlighting"
zinit light "zsh-users/zsh-completions"
zinit light "zsh-users/zsh-history-substring-search"
zinit light "zsh-users/zsh-common-aliases"
zinit light "zsh-users/zsh-command-not-found"
zinit light "zsh-users/zsh-interactive-cd"
zinit light "zsh-users/zsh-nmap"
zinit light "zoxide/zoxide"
zinit light "marlonrichert/zsh-autocomplete"
zinit light "marlonrichert/zsh-edit"
zinit light "marlonrichert/zsh-hist"
zinit light "marlonrichert/zcolors"
zinit light "romkatv/zsh-defer"
zinit light "Aloxaf/fzf-tab"
zinit light "junegunn/fzf"
zinit light "supercrabtree/k"
zinit light "djui/alias-tips"
zinit light "nvbn/thefuck"
zinit light "garabik/grc"
zinit light "ptavares/zsh-direnv"
zinit light "b4b4r07/enhancd"
zinit light "molovo/revolver"
zinit light "lukechilds/zsh-better-npm-completion"
zinit light "darvid/zsh-poetry"
zinit light "hlissner/zsh-autopair"
zinit light "z-shell/zsh-lsd"
zinit light "MichaelAquilina/zsh-autoswitch-virtualenv"

# oh-my-zsh
zinit light "ohmyzsh/ohmyzsh"
zinit snippet "ohmyzsh/ohmyzsh/lib/completion.zsh"
zinit snippet "ohmyzsh/ohmyzsh/plugins/colorize/colorize.plugin.zsh"
zinit snippet "ohmyzsh/ohmyzsh/plugins/gh/gh.plugin.zsh"
zinit snippet "ohmyzsh/ohmyzsh/plugins/pipenv/pipenv.plugin.zsh"
zinit snippet "ohmyzsh/ohmyzsh/plugins/git-extras/git-extras.plugin.zsh"
zinit snippet "ohmyzsh/ohmyzsh/plugins/gnu-utils/gnu-utils.plugin.zsh"
zinit snippet "ohmyzsh/ohmyzsh/plugins/zsh-256color/zsh-256color.plugin.zsh"
zinit snippet "ohmyzsh/ohmyzsh/plugins/bgnotify/bgnotify.plugin.zsh"
zinit snippet "ohmyzsh/ohmyzsh/plugins/debian/debian.plugin.zsh"
zinit snippet "ohmyzsh/ohmyzsh/plugins/fasd/fasd.plugin.zsh"
zinit snippet "ohmyzsh/ohmyzsh/plugins/magic-enter/magic-enter.plugin.zsh"
zinit snippet "ohmyzsh/ohmyzsh/plugins/npm/npm.plugin.zsh"
zinit snippet "ohmyzsh/ohmyzsh/plugins/postgres/postgres.plugin.zsh"
zinit snippet "ohmyzsh/ohmyzsh/plugins/python/python.plugin.zsh"
zinit snippet "ohmyzsh/ohmyzsh/plugins/sudo/sudo.plugin.zsh"
zinit snippet "ohmyzsh/ohmyzsh/plugins/systemd/systemd.plugin.zsh"
zinit snippet "ohmyzsh/ohmyzsh/plugins/web-search/web-search.plugin.zsh"
zinit snippet "ohmyzsh/ohmyzsh/plugins/pip/pip.plugin.zsh"
zinit snippet "ohmyzsh/ohmyzsh/plugins/virtualenv/virtualenv.plugin.zsh"
zinit snippet "ohmyzsh/ohmyzsh/plugins/virtualenvwrapper/virtualenvwrapper.plugin.zsh"

# rupa/z
zinit ice as"program"
zinit light "rupa/z"

# changyuheng/fz
zinit ice as"program"
zinit light "changyuheng/fz"

# zsh-test-runner
zinit ice as"program"
zinit light "molovo/zsh-test-runner"
