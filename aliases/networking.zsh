#!/bin/zsh

if command -v ip >/dev/null 2>&1; then
  alias ip='ip --color=auto'
fi
alias ports='netstat -tulanp'
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

alias sniff1="sudo ngrep -d 'wlan1' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i wlan1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

alias iwconfig="sudo grc iwconfig"
alias allnet='sudo ~/.config/zsh/scripts/alternetwork.sh'
alias checkports='sudo ~/.config/zsh/scripts/checkports.sh'
