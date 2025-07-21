#!/usr/bin/zsh

# #Extract nmap information
function extractPorts(){
    ports="$(cat $1 | grep -oP '\d{1,5}/open' | awk '{print $1}' FS='/' | xargs | tr ' ' ',')"
    ip_address="$(cat $1 | grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' | sort -u | head -n 1)"
    echo -e "\n[*] Extracting information...\n"
    echo -e "\t[*] IP Address: $ip_address"
    echo -e "\t[*] Open ports: $ports\n"
    if command -v pbcopy >/dev/null 2>&1; then
        echo $ports | tr -d '\n' | pbcopy
        echo -e "[*] Ports copied to clipboard\n"
    elif command -v xclip >/dev/null 2>&1; then
        echo $ports | tr -d '\n' | xclip -sel clip
        echo -e "[*] Ports copied to clipboard\n"
    fi
}
	
#fzf improvement
function betterfzf(){
    fzf -m --preview '[[ $(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always {} || highlight -O ansi -l {} || coderay {} || rougify {} || cat {}) 2> /dev/null | head -500'
}

autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search


fh() {
    local selected
    selected=$(fc -lrn 1 | awk '!a[$0]++' | fzf --tac --no-sort +m)
    if [[ -n $selected ]]; then
        BUFFER=$selected
        zle accept-line
    fi
    zle reset-prompt
}

zle -N fh
bindkey '^E' fh

# Attach to exisiting tmux session
tsa(){
	if command -v tmux >/dev/null 2>&1; then
		tmux ls -F \#S > /dev/null 2>&1
		if [ $? -eq 0 ]
		then
			SESSION=$(tmux ls -F \#S | fzf --prompt "Attach to a TMUX session...")

			if [ ! -z "$SESSION" ]; then
				tmux attach -t "$SESSION"
			fi
		else
			echo "There is no existing TMUX session."
		fi
	else
		echo "tmux is not installed."
	fi
}

function top20() {
    du -ah . | sort -rh | head -20
}

# move files to trash instead of removing
trash(){
  mv $1 ~/.trash/
}

# beautiful CSVs
csv() {
  column -s, -t < $1 | less -$2 -N -S
}

# print terminal emulator color palette
color256() {
    local -a colors
    for i in {000..255}; do
        colors+=("%F{$i}$i%f")
    done
    print -cP $colors
}

# filter & kill active tmux sessions
tmux-kill(){
  if command -v tmux >/dev/null 2>&1; then
	  tmux list-sessions | awk 'BEGIN{FS=":"}{print $1}' | fzf | xargs -n 1 tmux kill-session -t
  else
	  echo "tmux is not installed."
  fi
}

# change directories in style
lfcd () {
	if command -v lf >/dev/null 2>&1; then
		tmp="$(mktemp)"
		lf -last-dir-path="$tmp" "$@"
		if [ -f "$tmp" ]; then
			dir="$(cat "$tmp")"
			rm -f "$tmp"
			[ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
		fi
	else
		echo "lf is not installed."
	fi
}

# ix.io pastebin
ix() {
    local opts
    local OPTIND
    [ -f "$HOME/.netrc" ] && opts='-n'
    while getopts ":hd:i:n:" x; do
        case $x in
            h) echo "ix [-d ID] [-i ID] [-n N] [opts]"; return;;
            d) $echo curl $opts -X DELETE ix.io/$OPTARG; return;;
            i) opts="$opts -X PUT"; local id="$OPTARG";;
            n) opts="$opts -F read:1=$OPTARG";;
        esac
    done
    shift $(($OPTIND - 1))
    [ -t 0 ] && {
        local filename="$1"
        shift
        [ "$filename" ] && {
            curl $opts -F f:1=@"$filename" $* ix.io/$id
            return
        }
        echo "^C to cancel, ^D to send."
    }
    curl $opts -F f:1='<-' $* ix.io/$id
}

# Time Elsewhere
zonetime(){
  echo "$(timedatectl list-timezones)" | fzf | read TZ
  echo "$TZ : $(date +'%m/%d/%Y %I:%M %p')"
  unset TZ
}

# Fast Clear
clear(){
  echo -en "\x1b[2J\x1b[1;1H"
}

# Start & Detach Process
detach-proc(){
  nohup $1 >/dev/null 2>&1 &
}

# Find Keycode
keycode() {
  xev | awk -F'[ )]+' '/^KeyPress/ { a[NR+2] } NR in a { printf "%-3s %s\n", $5, $8 }'
}

# disable NMI Watchdog
disable_nmi_watchdog() {
	if [[ "$(uname)" == "Linux" ]]; then
		sudo sysctl kernel.nmi_watchdog=0
	else
		echo "This function is only available on Linux."
	fi
}

vm-start() {
	if command -v VBoxManage >/dev/null 2>&1; then
		machine="$(VBoxManage list vms | fzf | awk '{gsub(/"/, "", $1); print $1}')"
		VBoxManage startvm $machine --type headless
	else
		echo "VirtualBox is not installed."
	fi
}

vm-tunnel() {
	if command -v VBoxManage >/dev/null 2>&1; then
		machine="$(VBoxManage list vms | fzf | awk '{gsub(/"/, "", $1); print $1}')"
		ip="$(VBoxManage guestproperty enumerate $machine | grep IP | grep-ip | head -n1)"
		abduco -n vm-tun ssh $1@$ip -D 1337 -C -q -N -v
	else
		echo "VirtualBox is not installed."
	fi
}

vm-connect() {
	if command -v VBoxManage >/dev/null 2>&1; then
		machine="$(VBoxManage list vms | fzf | awk '{gsub(/"/, "", $1); print $1}')"
		ip="$(VBoxManage guestproperty enumerate $machine | grep IP | grep-ip | head -n1)"
		if [ -z "$1" ]; then
			ssh $USER@$ip
		else
			ssh $1@$ip
		fi
	else
		echo "VirtualBox is not installed."
	fi
}

grep-ip() {
  text="$(cat < /dev/stdin)"
  echo "$(echo $text | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')"
}

lan-scan() {
	if command -v nmap >/dev/null 2>&1 && command -v ipcalc >/dev/null 2>&1; then
		host="$(ip addr | grep -v 'host lo' | grep -E 'inet\s' | grep-ip | head -n 1)"
		nwork=$(ipcalc $host | grep Network | grep-ip)
		echo "$(nmap -sP $nwork/24 | grep 'Nmap scan report' | fzf | grep-ip)"
	else
		echo "nmap and/or ipcalc are not installed."
	fi
}

lan-connect() {
  remote="$(lan-scan)"
  echo "username [leave empty if $USER]: "
  read username
  [[ -z "$username" ]] && username=$USER
  ssh $username@$remote
}

tlist() {
	if command -v tmuxinator >/dev/null 2>&1; then
		tmuxinator list | tail -n 1 | awk -v OFS="\n" '$1=$1' | fzf
	else
		echo "tmuxinator is not installed."
	fi
}

tstart() {
	if command -v tmuxinator >/dev/null 2>&1; then
		tmuxinator start "$(tlist)"
	else
		echo "tmuxinator is not installed."
	fi
}

tstop() {
	if command -v tmuxinator >/dev/null 2>&1; then
		tmuxinator stop "$(tlist)"
	else
		echo "tmuxinator is not installed."
	fi
}
# Domain Resolution

function DomainResolve() {

  local _host="$1"
  local _timeout="15"

  _host_ip=$(curl -ks -m "$_timeout" "https://dns.google.com/resolve?name=${_host}&type=A" | \
  jq '.Answer[0].data' | tr -d "\"" 2>/dev/null)

  if [[ -z "$_host_ip" ]] || [[ "$_host_ip" == "null" ]] ; then
    echo -en "Unsuccessful domain name resolution.\n"
  else
    echo -en "$_host > $_host_ip\n"
  fi
}

function historygram() {
  history | \
    awk '{print $2}' | \
    sort | \
    uniq -c | \
    sort -rn | \
    head -20 | \
    awk '!max{max=$1;}{r="";i=s=60*$1/max;while(i-->0)r=r"#";printf "%15s %5d %s %s",$2,$1,r,"\n";}'
}

# Usage: palette
palette() {
    for code in {0..255}; do
        print -Pn "%F{$code}${(l:3::0:)code}%f "
        if (( ($code + 1) % 10 == 0 )); then
            print ""
        fi
    done
    print ""
}


# Usage: printc COLOR_CODE
printc() {
    local color="%F{$1}"
    echo -E ${(qqqq)${(%)color}}
}


autoload -Uz add-zsh-hook

function reset_broken_terminal () {
	printf '%b' '\e[0m\e(B\e)0\017\e[?5l\e7\e[0;0r\e8'
}

add-zsh-hook -Uz precmd reset_broken_terminal

# find-in-file - usage: fif <SEARCH_TERM>
fif() {
  if [ ! "$#" -gt 0 ]; then
    echo "Need a string to search for!";
    return 1;
  fi  
  
  rg --files-with-matches --no-messages "$1" | fzf $FZF_PREVIEW_WINDOW --preview "rg --ignore-case --pretty --context 10 '$1' {}"
}

# Enable math functions
zmodload zsh/mathfunc

# prevent man from displaying lines wider than 120 characters
function man(){
    MANWIDTH=120
    if (( MANWIDTH > COLUMNS )); then
        MANWIDTH=$COLUMNS
    fi
    MANWIDTH=$MANWIDTH /usr/bin/man $*
    unset MANWIDTH
}

# cd to directory and list files
auto_ls() {
	emulate -L zsh
	echo
  if command -v colorls &>/dev/null; then
    colorls --gs -x --sd
  else
    ls --gs -x --sd --color=always
  fi
}

# Check if auto-ls has already been added to the chpwd_functions array. This
# ensures that resourcing the zshrc file doesnt cause ls to be run twice.
if [[ ! " ${chpwd_functions[*]} " =~ "auto_ls" ]]; then
  chpwd_functions=(auto_ls $chpwd_functions)
fi

# Smart cd function. cd to parent dir if file is given.
function cd() {
    if (( ${#argv} == 1 )) && [[ -f ${1} ]]; then
        [[ ! -e ${1:h} ]] && return 1
        print "Correcting ${1} to ${1:h}"
        builtin cd ${1:h}
    else
        builtin cd "$@"
    fi
}

# Create Directory and cd to it
function mkcd() {
    if (( ARGC != 1 )); then
        printf 'usage: mkcd <new-directory>\n'
        return 1;
    fi
    if [[ ! -d "$1" ]]; then
        command mkdir -p "$1"
    else
        printf '`%s'\'' already exists: cd-ing.\n' "$1"
    fi
    builtin cd "$1"
}

# Create temporary directory and cd to it
function cdt() {
    builtin cd "$(mktemp -d)"
    builtin pwd
}

# show newest files
newest (){
  find . -type f -printf '%TY-%Tm-%Td %TT %p\n' | \
  grep -v cache | \
  grep -v '.hg' | grep -v '.git' | \
  sort -r | \
  less
}


# http://www.commandlinefu.com/commands/view/7294/backup-a-file-with-a-date-time-stamp
buf () {
    oldname=$1;
    if [ "$oldname" != "" ]; then
        datepart=$(date +%Y-%m-%d);
        firstpart=`echo $oldname | cut -d "." -f 1`;
        newname=`echo $oldname | sed s/$firstpart/$firstpart.$datepart/`;
        cp -R ${oldname} ${newname};
    fi
}
dobz2 () {
    name=$1;
    if [ "$name" != "" ]; then
        tar cvjf $1.tar.bz2 $1
    fi
}

atomtitles () { curl --silent $1 | xmlstarlet sel -N atom="http://www.w3.org/2005/Atom" -t -m /atom:feed/atom:entry -v atom:title -n}


function printHookFunctions () {
    print -C 1 ":::pwd_functions:" $chpwd_functions
    print -C 1 ":::periodic_functions:" $periodic_functions
    print -C 1 ":::precmd_functions:" $precmd_functions
    print -C 1 ":::preexec_functions:" $preexec_functions
    print -C 1 ":::zshaddhistory_functions:" $zshaddhistory_functions
    print -C 1 ":::zshexit_functions:" $zshexit_functions
}

# reloads all functions
r() {
    local f
    f=(~/.config/zsh/functions.d/*(.))
    unfunction $f:t 2> /dev/null
    autoload -U $f:t
}


# Rename files in a directory in an edited list fashion
function massmove () {
    ls > ls; paste ls ls > ren; $EDITOR ren; sed 's/^/mv /' ren|bash; rm ren ls
}

# Put a console clock in top right corner
function clock () {
    while sleep 1;
    do
        tput sc
        tput cup 0 $(($(tput cols)-29))
        date
        tput rc
    done &
}

function apt-import-key () {
	if [[ "$(uname)" == "Linux" ]]; then
		gpg --keyserver subkeys.pgp.net --recv-keys $1 | gpg --armor --export $1 | sudo apt-key add -
	else
		echo "This function is only available on Debian-based systems."
	fi
}

# create a new script, automatically populating the shebang line, editing the
# script, and making it executable.
shebang() {
  if [[ -z $1 ]]; then
    echo "Please provide a script name."
    return
  fi
  
  local script_name=$1
  shift
  local add_to_path=false
  
  if [[ $1 == '-p' ]]; then
    add_to_path=true
    shift
  fi
  
  cat > $script_name <<EOF
#! /bin/zsh  

$*  
EOF
  
  chmod +x $script_name
  
  echo "New executable zsh script created: $script_name"
  
  if $add_to_path; then
    echo "Adding $script_name to PATH..."
    echo 'export PATH="$PATH:$(dirname $script_name)"' >> ~/.zshrc
    source ~/.zshrc
    echo "$script_name added to PATH!"
  fi
}

#Display running processes in FZF

function rpfzf() {
  local pid
  pid=$(ps aux --sort=-%cpu | sed -e '1d' | fzf --reverse -m | awk '{print $2}')

  if [[ -n $pid ]]; then
    echo "Selected process ID(s): $pid"
    read -q "REPLY?Kill selected process(es)? (y/n) "
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      echo "Killing process(es)..."
      echo $pid | xargs kill
    fi
  fi
}
# Display cheatsheet for giving command. 
cheat() {
  curl -s "https://cheat.sh/$1" 
}

# a rough equivalent to "hg out"
git-out() {
    for i in $(git push -n $* 2>&1 | awk '$1 ~ /[a-f0-9]+\.\.[a-f0-9]+/ { print $1; }')
    do
        git xlog $i
    done
}

  # kill pid that listens on given port
kport() {
  local port=$1
  local pid=$(lsof -t -i :$port)
  if [[ -n $pid ]]; then
    echo "Killing process $pid listening on port $port"
    kill $pid
  else
    echo "No process found listening on port $port"
  fi
}
# Query Wikipedia via console over DNS
wp() {
    dig +short txt ${1}.wp.dg.cx
}

# translate via google language tools
translate() {
    wget -qO- "http://ajax.googleapis.com/ajax/services/language/translate?v=1.0&q=$1&langpair=$2|${3:-en}" | sed 's/.*"translatedText":"\([^"]*\)".*}/\1\n/'
}

globalias() {
   if [[ $LBUFFER =~ ' [A-Z0-9]+$' ]]; then
     zle _expand_alias
     zle expand-word
   fi
   zle self-insert
}

zle -N globalias

bindkey " " globalias
bindkey "^ " magic-space           # control-space to bypass completion
bindkey -M isearch " " magic-space # normal space during searches

# delete-to-previous-slash
backward-delete-to-slash () {
  local WORDCHARS=${WORDCHARS//\//}
  zle .backward-delete-word
}
zle -N backward-delete-to-slash
# bind to control Y
bindkey "^Y" backward-delete-to-slash

# This hacks around the problem by making a '$' command that simply runs
# whatever arguments are passed to it. So you can copy
#   '$ echo hello world'
# and it will run 'echo hello world'
function \$() { 
  "$@"
}


# some useful fzf-grepping functions for python
function pip-list() {
  pip list "$@" | fzf --header-lines 2 --reverse --nth 1 --multi | awk '{print $1}'
}
function pip-search() {
  # 'pip search' is gone; try: pip install pip_search
  if ! (( $+commands[pip_search] )); then echo "pip_search not found (Try: pip install pip_search)."; return 1; fi
  if [[ -z "$1" ]]; then echo "argument required"; return 1; fi
  pip-search "$@" | fzf --reverse --multi --no-sort --header-lines=4 | awk '{print $3}'
}
function conda-list() {
  conda list "$@" | fzf --header-lines 3 --reverse --nth 1 --multi | awk '{print $1}'
}
function pipdeptree() {
  python -m pipdeptree "$@" | fzf --reverse
}
function pipdeptree-vim() {   # e.g. pipdeptree -p <package>
  python -m pipdeptree "$@" | vim - +"set ft=config foldmethod=indent" +"norm zR"
}

## Docker Functions

# Select a docker container to start and attach to
function da() {
  local cid
  cid=$(docker ps -a | sed 1d | fzf -1 -q "$1" | awk '{print $1}')

  [ -n "$cid" ] && docker start "$cid" && docker attach "$cid"
}

# Select a running docker container to stop
function ds() {
  local cid
  cid=$(docker ps | sed 1d | fzf -q "$1" | awk '{print $1}')

  [ -n "$cid" ] && docker stop "$cid"
}

# Select a docker container to remove
function drm() {
  local cid
  cid=$(docker ps -a | sed 1d | fzf -q "$1" | awk '{print $1}')

  [ -n "$cid" ] && docker rm "$cid"
}

rgfzf () {
    # ripgrep
    if [ ! "$#" -gt 0 ]; then
        echo "Usage: rgfzf <query>"
        return 1
    fi
    rg --files-with-matches --no-messages "$1" | \
        fzf --prompt "$1 > " \
        --reverse --multi --preview "rg --ignore-case --pretty --context 10 '$1' {}"
}

function plugin-update {
  ZPLUGINDIR=${ZPLUGINDIR:-$HOME/.config/zsh/plugins}
  for d in $ZPLUGINDIR/*/.git(/); do
    echo "Updating ${d:h:t}..."
    command git -C "${d:h}" pull --ff --recurse-submodules --depth 1 --rebase --autostash
  done
}

##? Clone a plugin, identify its init file, source it, and add it to your fpath.
function plugin-load {
  local repo plugdir initfile initfiles=()
  : ${ZPLUGINDIR:=${ZDOTDIR:-~/.config/zsh}/plugins}
  for repo in $@; do
    plugdir=$ZPLUGINDIR/${repo:t}
    initfile=$plugdir/${repo:t}.plugin.zsh
    if [[ ! -d $plugdir ]]; then
      echo "Cloning $repo..."
      git clone -q --depth 1 --recursive --shallow-submodules \
        https://github.com/$repo $plugdir
    fi
    if [[ ! -e $initfile ]]; then
      initfiles=($plugdir/*.{plugin.zsh,zsh-theme,zsh,sh}(N))
      (( $#initfiles )) || { echo >&2 "No init file '$repo'." && continue }
      ln -sf $initfiles[1] $initfile
    fi
    fpath+=$plugdir
    (( $+functions[zsh-defer] )) && zsh-defer . $initfile || . $initfile
  done
}

function plugin-compile {
  ZPLUGINDIR=${ZPLUGINDIR:-$HOME/.config/zsh/plugins}
  autoload -U zrecompile
  local f
  for f in $ZPLUGINDIR/**/*.zsh{,-theme}(N); do
    zrecompile -pq "$f"
  done
}
