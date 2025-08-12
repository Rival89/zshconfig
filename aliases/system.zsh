#!/bin/zsh

alias shutdown='sudo shutdown'
alias reboot='sudo reboot'

# Human-readable disk usage
alias df='df -Tha --total'
# Show memory usage in megabytes
alias free='free -mt'
# Show processes in a tree format
alias ps='ps auxf'
# Interactive process viewer
alias ht='htop'
# Install python requirements
alias pip3r='pip3 install -r requirements.txt'
# Show CPU temperature
alias cputemp='sensors | grep Core'
# Shortcut for sudo make install
alias smi='sudo make install'

# Show kernel messages
alias dmesg='sudo dmesg'

# Systemd/systemctl helpers
if command -v systemctl >/dev/null 2>&1; then
  alias ctl='sudo systemctl'
  alias sysdeath='sudo systemctl start poweroff.target' # Power off the system
  alias start="sudo systemctl start"
  alias stop="sudo systemctl stop"
  alias status="sudo systemctl status"
  alias restart="sudo systemctl restart"
  alias jc='journalctl -xe' # Show journal logs
  alias sc='systemctl'
  alias ssc='sudo systemctl'
fi

# SysVinit/service control
alias svc='sudo service'

alias blkid='sudo grc blkid'
alias chmod='chmod --preserve-root -v'
alias chown='chown --preserve-root -v'

# APT package management helpers (for Debian/Ubuntu)
if command -v apt-get >/dev/null 2>&1; then
  alias acs='apt-cache show'
  alias agi='sudo apt-get install'
  alias ag='sudo apt-get'
  alias agu='sudo apt-get update'
  alias agug='sudo apt-get upgrade'
  alias aguu='agu && agug' # Update and upgrade
  alias agr='sudo apt-get uninstall'
  alias agp='sudo apt-get purge'
  alias aga='sudo apt-get autoremove'
  alias apt='sudo apt'
fi

# Automatically sudo commands that need it
alias netdiscover='sudo netdiscover'
alias apachectl='sudo apachectl'
alias snap='sudo snap'
