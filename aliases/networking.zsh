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

# Run nmap with the vuln script
alias vmap="sudo nmap --script=vuln"
# Colorize nmap output
alias nmap="sudo grc nmap"
# Redirect all TCP traffic to port 443
alias reverseip="sudo iptables -t nat -A PREROUTING -p tcp --dport 1:65534 -j REDIRECT --to-ports 443"

# Wireless interface aliases (for systems that have iw/iwconfig)
if command -v iw >/dev/null 2>&1 && command -v iwconfig >/dev/null 2>&1; then
  # Change MAC address of interfaces
  alias chec0="ec0d; sudo macchanger -r ech0; ec0up"
  alias ch1="1d; sudo macchanger -r wlan1; 1up"
  alias ch2="2d; sudo macchanger -r wlan2; 2up"
  # Create monitor mode interfaces
  alias mkech0="sudo iw wlan1 interface add ech0 type monitor"
  alias mksn0w="sudo iw wlan2 interface add sn0w type monitor"
  # Set interface mode to Monitor or Managed
  alias 1mon="1d; sudo iwconfig wlan1 mode Monitor; 1up"
  alias 1man="1d; sudo iwconfig wlan1 mode Managed; 1up"
  alias 2mon="2d; sudo iwconfig wlan2 mode Monitor; 2up"
  alias 2man="2d; sudo iwconfig wlan2 mode Managed; 2up"
  # Delete monitor mode interface
  alias killech0="sudo iw dev ech0 del"
  # Unmanage a network interface
  alias dropnet="sudo unmanage_interface -i"
fi

# Sniff for GET/POST requests on wlan1
alias sniff1="sudo ngrep -d 'wlan1' -t '^(GET|POST) ' 'tcp and port 80'"
# Dump HTTP traffic on wlan1
alias httpdump="sudo tcpdump -i wlan1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# Colorize iwconfig output
alias iwconfig="sudo grc iwconfig"
# Run the alternetwork script
alias allnet='sudo ~/.config/zsh/scripts/alternetwork.sh'
# Run the checkports script
alias checkports='sudo ~/.config/zsh/scripts/checkports.sh'
