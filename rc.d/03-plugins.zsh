#!/bin/zsh

# Install zinit
if [[ ! -f "$HOME/.local/share/zinit/zinit.zsh" ]]; then
  mkdir -p "$HOME/.local/share/zinit"
  git clone https://github.com/zdharma-continuum/zinit.git "$HOME/.local/share/zinit" || return
fi
source "$HOME/.local/share/zinit/zinit.zsh"

# Load plugins
zinit light "zsh-users/zsh-autosuggestions"
zinit light "zsh-users/zsh-syntax-highlighting"
zinit light "zsh-users/zsh-completions"
zinit light "zsh-users/zsh-history-substring-search"
zinit light "zoxide/zoxide"
zinit light "marlonrichert/zsh-autocomplete"
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
if command -v lsd >/dev/null 2>&1; then
  zinit light "z-shell/zsh-lsd"
fi
if command -v python >/dev/null 2>&1; then
  zinit light "MichaelAquilina/zsh-autoswitch-virtualenv"
fi
# oh-my-zsh
zinit snippet OMZL::completion.zsh
zinit snippet OMZP::colorize/colorize.plugin.zsh
zinit snippet OMZP::gh/gh.plugin.zsh
zinit snippet OMZP::pipenv/pipenv.plugin.zsh
zinit snippet OMZP::git-extras/git-extras.plugin.zsh
zinit snippet OMZP::gnu-utils/gnu-utils.plugin.zsh
zinit snippet OMZP::zsh-256color/zsh-256color.plugin.zsh
zinit snippet OMZP::bgnotify/bgnotify.plugin.zsh
zinit snippet OMZP::debian/debian.plugin.zsh
zinit snippet OMZP::fasd/fasd.plugin.zsh
zinit snippet OMZP::magic-enter/magic-enter.plugin.zsh
zinit snippet OMZP::npm/npm.plugin.zsh
zinit snippet OMZP::postgres/postgres.plugin.zsh
zinit snippet OMZP::python/python.plugin.zsh
zinit snippet OMZP::sudo/sudo.plugin.zsh
zinit snippet OMZP::systemd/systemd.plugin.zsh
zinit snippet OMZP::web-search/web-search.plugin.zsh
zinit snippet OMZP::pip/pip.plugin.zsh
zinit snippet OMZP::virtualenv/virtualenv.plugin.zsh
zinit snippet OMZP::virtualenvwrapper/virtualenvwrapper.plugin.zsh
zinit snippet OMZP::command-not-found/command-not-found.plugin.zsh

# rupa/z
zinit ice as"program"
zinit light "rupa/z"

# changyuheng/fz
zinit ice as"program"
zinit light "changyuheng/fz"
