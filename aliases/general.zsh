#!/bin/zsh

if command -v lsd >/dev/null 2>&1; then
  alias ls='lsd'
fi
alias sourcezsh='source ~/.zshrc'
alias fullclock='tty-clock -csSb -C3'
alias xcd='cd "$(xplr --print-pwd-as-result)"'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'

# Show top 10 most used commands
alias top10='history | awk '\''{a[$2]++}END{for(i in a){print a[i] " " i}}'\'' | sort -rn | head'
# Reload zshrc and enable fzf-tab
alias szfzf="sourcezsh && enable-fzf-tab"

# Tmux
alias mux='tmuxinator'
alias tmux='TERM=screen-256color-bce tmux'
alias t="tmux"
alias ta="tmux a"

# Shell helpers
alias which >&/dev/null && unalias which
alias q=exit
alias clr=clear
alias sudo='sudo '
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -pv'
alias wget='wget -c'
alias path='echo -e ${PATH//:/\\n}'
alias chmox='chmod +x'
alias mk=make
alias gurl='curl --compressed'

# Show full history
alias history="history 0"

# Remove zsh completion cache and re-initialize
alias rmzcomp="rm -f ~/.zcompdump; compinit"
# Custom neofetch with ascii art
alias neofetch="/bin/neofetch --backend ascii --source $HOME/.config/neofetch/ascii --size '180px' --colors 5 5 7 2 2 7"
# Easy command-line calculator
alias eq="cc"
# Show a summary of command history
alias historysummary="history | awk '{a[\$2]++} END{for(i in a){printf \"%5d\t%s\n\",a[i],i}}'| sort -rn| head -30"
# Execute a new shell
alias exsh="exec $SHELL"
# Execute the last command as root
alias asroot='sudo $(fc -ln -1)'
# Pipe output to fzf (global alias)
alias -g Z=" | fzf"
# Show PATH in a readable format
alias showpath='echo -e "${PATH//:/\\n}"'
# Show FPATH in a readable format
alias showfpath='echo -e "${FPATH//:/\\n}"'

if command -v pyenv >/dev/null 2>&1; then
  alias pyenvi='eval "$(pyenv init -)"'
  alias pv3='pyenv virtualenv'
fi

# Lazy script execution
alias lzy='cd /usr/bin/lscript;sudo ./l'
# Quick cd with zoxide
alias x="zqi"
# Reset terminal
alias vtn='echo "X[mX(BX)0OX[?5lX7X[rX8" | tr '\''XO'\'' '\''\033\017'\'''

# ls aliases
alias ll='ls -alh --color=auto'
alias la='ls -A'
alias l='ls -CF'

# Directory stack jump shortcuts (requires AUTO_PUSHD option)
alias 1='cd +1' # Go to the 1st directory in the stack
alias 2='cd +2' # Go to the 2nd directory in the stack
alias 3='cd +3' # Go to the 3rd directory in the stack
alias 4='cd +4' # Go to the 4th directory in the stack
alias 5='cd +5' # Go to the 5th directory in the stack
alias 6='cd +6' # Go to the 6th directory in the stack
alias 7='cd +7' # Go to the 7th directory in the stack
alias 8='cd +8' # Go to the 8th directory in the stack
alias 9='cd +9' # Go to the 9th directory in the stack

# bat alias with a specific theme
alias bat='batcat --theme base16 -p'
alias curl='sudo grc curl'
