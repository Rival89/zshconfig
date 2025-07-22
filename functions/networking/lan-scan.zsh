lan-scan() {
  host="$(ip addr | grep -v 'host lo' | grep -E 'inet\s' | grep-ip | head -n 1)"
  nwork=$(ipcalc $host | grep Network | grep-ip)
  echo "$(nmap -sP $nwork/24 | grep 'Nmap scan report' | fzf | grep-ip)"
}
