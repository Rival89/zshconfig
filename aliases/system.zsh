#!/bin/zsh

alias shutdown='sudo shutdown'
alias reboot='sudo reboot'

alias df='df -Tha --total'
alias free='free -mt'
alias ps='ps auxf'
alias ht='htop'
alias pip3r='pip3 install -r requirements.txt'
alias cputemp='sensors | grep Core'
alias smi='sudo make install'

alias dmesg='sudo dmesg'

# systemctl helpers
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

# service control
alias svc='sudo service '

alias blkid='sudo grc blkid'
alias chmod='chmod --preserve-root -v'
alias chown='chown --preserve-root -v'

# Package management
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

# sudoify commands
alias netdiscover='sudo netdiscover'
alias apachectl='sudo apachectl'
alias snap='sudo snap'
