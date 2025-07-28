#!/bin/zsh

if command -v lsd >/dev/null 2>&1; then
  alias ls='lsd'
fi
alias sourcezsh='source ~/.zshrc'
alias pkm='$ZSH_CONFIG/scripts/pkm.sh'
alias fullclock='tty-clock -csSb -C3'
alias xcd='cd "$(xplr --print-pwd-as-result)"'
alias lg="lazygit"
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
if command -v ip >/dev/null 2>&1; then
  alias ip='ip --color=auto'
fi
alias top10='history | awk '\''{a[$2]++}END{for(i in a){print a[i] " " i}}'\'' | sort -rn | head'
alias szfzf="sourcezsh && enable-fzf-tab"
# Tmuxinator - Tmux Session Manager
alias mux='tmuxinator'
alias tmux='TERM=screen-256color-bce tmux'
alias t="tmux"
alias ta="tmux a"


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
alias ports='netstat -tulanp'
alias chmox='chmod +x'
alias mk=make
alias gurl='curl --compressed'

#AI
alias autogpt="docker-compose run --rm auto-gpt"

alias shutdown='sudo shutdown'
alias reboot='sudo reboot'
# force zsh to show the complete history
alias history="history 0"
# memory/cpu
alias df='df -Tha --total'
alias free='free -mt'
alias ps='ps auxf'
alias ht='htop'
alias pip3r='pip3 install -r requirements.txt'
alias cputemp='sensors | grep Core'
alias gfcd='gfcd() { git clone "$1" && cd "$(basename "$1" .git)"; }; gfcd'
alias smi='sudo make install'
alias howmany="howmanypeoplearearound -a wlan1 -v -s '200'"
if command -v ifconfig >/dev/null 2>&1; then
  alias ifconfig="sudo grc ifconfig"
  alias 1d='sudo ifconfig wlan1 down'
  alias 1up='sudo ifconfig wlan1 up'
  alias 2d='sudo ifconfig wlan2 down'
  alias 2up='sudo ifconfig wlan2 up'
  alias 0d='sudo ifconfig wlan0 down'
  alias 0up='sudo ifconfig wlan0 up'
  alias ec0up="sudo ifconfig ech0 up"
  alias ec0d="sudo ifconfig ech0 down"
fi
alias vmap="sudo nmap --script=vuln"
alias nmap="sudo grc nmap"
alias reverseip="sudo iptables -t nat -A PREROUTING -p tcp --dport 1:65534 -j REDIRECT --to-ports 443"
if command -v iw >/dev/null 2>&1 && command -v iwconfig >/dev/null 2>&1; then
  alias chec0="ec0d; sudo macchanger -r ech0; ec0up"
  alias ch1="1d; sudo macchanger -r wlan1; 1up"
  alias ch2="2d; sudo macchanger -r wlan2; 2up"
  alias mkech0="sudo iw wlan1 interface add ech0 type monitor"
  alias mksn0w="sudo iw wlan2 interface add sn0w type monitor"
  alias 1mon="1d; sudo iwconfig wlan1 mode Monitor; 1up"
  alias 1man="1d; sudo iwconfig wlan1 mode Managed; 1up"
  alias 2mon="2d; sudo iwconfig wlan2 mode Monitor; 2up"
  alias 2man="2d; sudo iwconfig wlan2 mode Managed; 2up"
  alias killech0="sudo iw dev ech0 del"
  alias dropnet="sudo unmanage_interface -i"
fi
alias rmzcomp="rm -f ~/.zcompdump; compinit"
alias neofetch="/bin/neofetch --backend ascii --source $HOME/.config/neofetch/ascii --size '180px' --colors 5 5 7 2 2 7"
alias eq="cc"
alias sniff1="sudo ngrep -d 'wlan1' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i wlan1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""
alias historysummary="history | awk '{a[\$2]++} END{for(i in a){printf \"%5d\t%s\n\",a[i],i}}'| sort -rn| head -30"
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
alias iwconfig="sudo grc iwconfig"
alias dmesg='sudo dmesg'
alias exsh="exec $SHELL"
alias asroot='sudo $(fc -ln -1)'
alias -g Z=" | fzf" # Can change 'Z' to whatever you like
alias showpath='echo -e "${PATH//:/\\n}"'
alias showfpath='echo -e "${FPATH//:/\\n}"'
alias pyenvi='eval "$(pyenv init -)"'
alias pv3='pyenv virtualenv'
alias lzy='cd /usr/bin/lscript;sudo ./l'
alias x="zqi"
alias trufflehog='trufflehog() { sudo docker run --rm -it -v "$PWD:/pwd" trufflesecurity/trufflehog:latest github --repo "$1"; }; trufflehog'
alias allnet='sudo systemctl restart wpa_supplicant && sudo systemctl restart networking && sudo systemctl restart NetworkManager'
alias vtn='echo "X[mX(BX)0OX[?5lX7X[rX8" | tr '\''XO'\'' '\''\033\017'\'''
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
if command -v systemctl >/dev/null 2>&1; then
  alias ctl='sudo systemctl '
  alias sysdeath='sudo systemctl start poweroff.target'
  alias start=" sudo systemctl start"
  alias stop=" sudo systemctl stop"
  alias status=" sudo systemctl status"
  alias restart=" sudo systemctl restart"
  alias jc='journalctl -xe'
  alias sc=systemctl
  alias ssc='sudo systemctl'
fi
alias venom='sudo docker run --rm -ti vittring/venom:yggdrasil'

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
alias blkid='sudo grc blkid'
alias chmod='chmod --preserve-root -v'
alias chown='chown --preserve-root -v'
alias curl='sudo grc curl'
alias gfc="git clone"
alias ll='ls -alh --color=auto'
if command -v apt-get >/dev/null 2>&1; then
  alias acs='apt-cache show'
  alias agi='sudo apt-get install'
  alias ag='sudo apt-get'
  alias agu='sudo apt-get update'
  alias agug='sudo apt-get upgrade'
  alias aguu='agu && agug'
  alias agr='sudo apt-get uninstall'
  alias agp='sudo apt-get purge'
  alias aga='sudo apt-get autoremove'
  alias apt='sudo apt'
fi
alias ctl='sudo service '
alias altnet='sudo ~/.config/zsh/scripts/alternetwork.sh'
alias checkports='sudo ~/.config/zsh/scripts/checkports.sh'

# sudoify commands
alias netdiscover='sudo netdiscover'
alias apachectl='sudo apachectl'
alias snap='sudo snap'

# make gpg work
# https://unix.stackexchange.com/questions/257061/
# gentoo-linux-gpg-encrypts-properly-a-file-passed-
# through-parameter-but-throws-i/257065#257065
GPG_TTY=$(tty)
export GPG_TTY

autoload -U zmv

alias lg='ltk_lg'
alias pg='ltk_pg'
alias nsg='ltk_netsg'
alias tczero='truncate -s 0'
alias mailtcz='truncate -s 0 /var/mail/${USER}'
alias showSystemVersion='ltk_system_version'
alias tf='ltk_tail'
alias killByPort='ltk_kill_by_port'
alias showPath='echo $PATH'
alias deleteAllSpace="sed -i '/^\s*$/d'"

# Proxy
alias setHttpV2rayProxy='ltk_http_v2ray_proxy'
alias unsetHttpProxy='ltk_unset_http_proxy'

# Mac
alias macAppInstallSourceAll='ltk_macos_enable_all_installation_sources'
