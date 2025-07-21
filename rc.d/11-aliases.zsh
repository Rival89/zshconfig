#!/bin/zsh

alias ls='lsd'
alias sourcezsh='source ~/.zshrc'
alias lg="lazygit"
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias ip='ip --color=auto'
# Tmuxinator - Tmux Session Manager
alias mux='tmuxinator'
alias tmux='TERM=screen-256color-bce tmux'
alias ta="tmux a"

alias q=exit
alias clr=clear
alias sudo='sudo '
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -pv'
alias wget='wget -c'
alias path='echo -e ${PATH//:/\\n}'
alias ports='netstat -tulanp'
alias chmox='chmod +x'
alias mk=make
alias gurl='curl --compressed'

#AI
alias autogpt="docker-compose run --rm auto-gpt"

# force zsh to show the complete history
alias history="history 0"
# memory/cpu
alias df='df -Tha --total'
alias free='free -mt'
alias ps='ps auxf'
alias ht='htop'
alias pip3r='pip3 install -r requirements.txt'

alias vmap="nmap --script=vuln"
alias nmap="grc nmap"
alias rmzcomp="rm -f ~/.zcompdump; compinit"
alias historysummary="history | awk '{a[\$2]++} END{for(i in a){printf \"%5d\t%s\n\",a[i],i}}'| sort -rn| head -30"
alias iwconfig="grc iwconfig"
alias dmesg='dmesg'
alias exsh="exec $SHELL"
alias asroot='sudo $(fc -ln -1)'
alias -g Z=" | fzf" # Can change 'Z' to whatever you like
alias showpath='echo -e "${PATH//:/\\n}"'
alias showfpath='echo -e "${FPATH//:/\\n}"'
alias pyenvi='eval "$(pyenv init -)"'
alias pv3='pyenv virtualenv'

alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias ctl='systemctl '
alias start="systemctl start"
alias stop="systemctl stop"
alias status="systemctl status"
alias restart="systemctl restart"
alias reboot="systemctl start reboot.target"

alias jc='journalctl -xe'
alias sc=systemctl
alias ssc='sudo systemctl'

if (( $+commands[exa] )); then
  alias exa="exa --group-directories-first --git";
  alias l="exa -blF";
  alias ll="exa -abghilmu";
  alias llm='ll --sort=modified'
  alias la="LC_COLLATE=C exa -ablF";
  alias tree='exa --tree'
fi

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
alias blkid='grc blkid'
alias chmod='chmod --preserve-root -v'
alias chown='chown --preserve-root -v'
alias curl='grc curl'
alias gfc="git clone"
alias ll='ls -alh --color=auto'
alias acs='apt-cache show'
alias agi='sudo apt-get install'
alias ag='sudo apt-get'
alias agu='sudo apt-get update'
alias agug='sudo apt-get upgrade'
alias aguu='agu && agug'
alias agr='sudo apt-get uninstall'
alias agp='sudo apt-get purge'
alias aga='sudo apt-get autoremove'
alias ctl='sudo service '
alias altnet='~/.config/zsh/scripts/alternetwork.sh'
alias checkports='~/.config/zsh/scripts/checkports.sh'
if (( $+commands[fasd] )); then
  # fuzzy completion with 'z' when called without args
  unalias z 2>/dev/null
  function z {
    [ $# -gt 0 ] && _z "$*" && return
    cd "$(_z -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
  }
fi

# ls tings
if [ -x "$(command -v colorls)" ]; then
    alias ls='colorls'
elif [ -x "$(command -v lsd)" ]; then
    alias ls='lsd'
else
    alias ls='ls -GpF'
fi

# sudoify commands
alias netdiscover='netdiscover'
alias apachectl='apachectl'
alias apt='apt'
alias snap='snap'

# make gpg work
# https://unix.stackexchange.com/questions/257061/
# gentoo-linux-gpg-encrypts-properly-a-file-passed-
# through-parameter-but-throws-i/257065#257065
GPG_TTY=$(tty)
export GPG_TTY

autoload -U zmv

function take {
  mkdir "$1" && cd "$1";
}; compdef take=mkdir

function zman {
  PAGER="less -g -I -s '+/^       "$1"'" man zshall;
}

# Create a reminder with human-readable durations, e.g. 15m, 1h, 40s, etc
function r {
  local time=$1; shift
  sched "$time" "notify-send --urgency=critical 'Reminder' '$@'; ding";
}; compdef r=sched
