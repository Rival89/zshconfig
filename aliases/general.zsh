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

alias top10='history | awk '\''{a[$2]++}END{for(i in a){print a[i] " " i}}'\'' | sort -rn | head'
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

alias history="history 0"

alias rmzcomp="rm -f ~/.zcompdump; compinit"
alias neofetch="/bin/neofetch --backend ascii --source $HOME/.config/neofetch/ascii --size '180px' --colors 5 5 7 2 2 7"
alias eq="cc"
alias historysummary="history | awk '{a[\$2]++} END{for(i in a){printf \"%5d\t%s\n\",a[i],i}}'| sort -rn| head -30"
alias exsh="exec $SHELL"
alias asroot='sudo $(fc -ln -1)'
alias -g Z=" | fzf"
alias showpath='echo -e "${PATH//:/\\n}"'
alias showfpath='echo -e "${FPATH//:/\\n}"'

if command -v pyenv >/dev/null 2>&1; then
  alias pyenvi='eval "$(pyenv init -)"'
  alias pv3='pyenv virtualenv'
fi

alias lzy='cd /usr/bin/lscript;sudo ./l'
alias x="zqi"
alias vtn='echo "X[mX(BX)0OX[?5lX7X[rX8" | tr '\''XO'\'' '\''\033\017'\'''

alias ll='ls -alh --color=auto'
alias la='ls -A'
alias l='ls -CF'

# Directory stack jump shortcuts
alias 1='cd +1'
alias 2='cd +2'
alias 3='cd +3'
alias 4='cd +4'
alias 5='cd +5'
alias 6='cd +6'
alias 7='cd +7'
alias 8='cd +8'
alias 9='cd +9'

alias bat='batcat --theme base16 -p'
alias curl='sudo grc curl'
