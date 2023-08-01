###!/bin/zsh
#setopt xtrace

#Zsh Autosuggestions

# Don't offer history completion; we have fzf, C-r, and
# zsh-history-substring-search for that.
ZSH_AUTOSUGGEST_STRATEGY=(completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=30
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bg=cyan,bold"

bindkey '\t' menu-select "$terminfo[kcbt]" menu-select
bindkey -M menuselect '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete
zstyle '*:compinit' arguments -D -i -u -C -w

setopt complete_in_word

# Completion algorithms
zstyle ':completion:*' completer _complete _prefix

# Rehash when completing commands
zstyle ":completion:*:commands" rehash 1

# Ignore internal zsh functions
zstyle ':completion:*:functions' ignored-patterns '_*'

# Smart case matching && match inside filenames
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Colors in completion
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Grouping of completion sources
zstyle ':completion:*:descriptions' format "%{${fg_bold[magenta]}%}= %d =%{$reset_color%}"
zstyle ':completion:*' group-name ""

# Speedup path completion
zstyle ':completion:*' accept-exact '*(N)'

# Cache expensive completions
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh

# List all processes for killall
zstyle ':completion:*:processes-names' command "ps -eo cmd= | sed 's:\([^ ]*\).*:\1:;s:\(/[^ ]*/\)::;/^\[/d'"

# Process completion shows all processes with colors
zstyle ':completion:*:*:*:*:processes' menu yes select
zstyle ':completion:*:*:*:*:processes' force-list always
zstyle ':completion:*:*:*:*:processes' command 'ps -A -o pid,user,cmd'
zstyle ':completion:*:*:*:*:processes' list-colors "=(#b) #([0-9]#)*=0=${color[green]}"
zstyle ':completion:*:*:kill:*:processes' command 'ps --forest -e -o pid,user,tty,cmd'

# all Tab widgets
zstyle ':autocomplete:*complete*:*' insert-unambiguous yes

# all history widgets
zstyle ':autocomplete:*history*:*' insert-unambiguous yes

# ^S
zstyle ':autocomplete:menu-search:*' insert-unambiguous yes

# Expand partial paths, e.g. cd f/b/z == cd foo/bar/baz (assuming no ambiguity)
zstyle ':completion:*:paths' path-completion yes

#zstyle ':completion:*' completer _complete _approximate
zstyle ':autocomplete:*' completer _complete _approximate
zstyle ':autocomplete:*' use-compctl false
zstyle ':autocomplete:*' verbose true

zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''


# Fuzzy match mistyped completions.
zstyle ':completion:*' completer _complete _list _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
# Increase the number of errors based on the length of the typed word.
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'
# Don't complete unavailable commands.
zstyle ':completion:*:functions' ignored-patterns '(_*|.*|pre(cmd|exec))'

# Omit parent and current directories from completion results when they are
# already named in the input.
zstyle ':completion:*:*:cd:*' ignore-parents parent pwd
# Merge multiple, consecutive slashes in paths
zstyle ':completion:*' squeeze-slashes true

# Exclude internal/fake envvars
zstyle ':completion::*:(-command-|export):*' fake-parameters ${${${_comps[(I)-value-*]#*,}%%,*}:#-*-}
# Sort array completion candidates
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# Autocompletion
zstyle -e ':autocomplete:list-choices:*' list-lines 'reply=( $(( LINES / 6 )) )'

# Override history search.
zstyle ':autocomplete:history-incremental-search-backward:*' list-lines 16

# History menu.
zstyle ':autocomplete:history-search-backward:*' list-lines 256

## enable completion features
autoload -Uz compinit
compinit -i
zstyle ':completion:*:*:cd:*' menu yes select
zstyle ':completion:*' menu yes select
#bindkey "^I" menu-complete
compinit -d ~/.cache/zcompdump
zstyle ':completion:*:*:*:*:*' menu yes select
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' rehash true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

## {{{ General completion technique

#zstyle ':completion:*' completer _complete _prefix _ignored _complete:-extended

zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:predict:*' completer _complete

## allow one error for every three characters typed in approximate completer
zstyle ':completion:*:approximate:'max-errors 'reply=( $((($#PREFIX+$#SUFFIX)/3 )) numeric )'

## e.g. f-1.j<TAB> would complete to foo-123.jpeg
zstyle ':completion:*:complete-extended:*' \
  matcher 'r:|[.,_-]=* r:|=*'

## {{{ Completion caching

zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path ~/.config/zsh/cache/$HOST

## }}}
## {{{ Expand partial paths

## e.g. /u/s/l/D/fs<TAB> would complete to
##  /usr/src/linux/Documentation/fs
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-slashes 'yes'

## don't complete backup files as executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '(aptitude-*|*\~)'

## start menu completion only if it could find no unambiguous initial string
#zstyle ':completion:*:correct:*'   insert-unambiguous true
#zstyle ':completion:*:corrections' format $'%{\e[0;31m%}%d (errors: %e)%{\e[0m%}'
#zstyle ':completion:*:correct:*'   original true


## format on completion
zstyle ':completion:*:descriptions'format $'%{\e[0;31m%}completing %B%d%b%{\e[0m%}'

## ignore duplicate entries
zstyle ':completion:*:history-words'   remove-all-dups yes
#zstyle ':completion:*:history-words'   stop yes

# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Don't complete uninteresting users
zstyle ':completion:*:users' ignored-patterns \
  adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
  dbus distcache dovecot fax ftp games gdm gkrellmd gopher \
  hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
  mailman mailnull mldonkey mysql nagios \
  named netdump news nfsnobody nobody 'nixbld*' nscd ntp nut nx openvpn \
  operator pcap postfix postgres privoxy pulse pvm quagga radvd \
  rpc rpcuser rpm shutdown squid sshd sync 'systemd-*' uucp vcsa xfs '_*'
# ... unless we really want to.
zstyle '*' single-ignored show

## {{{ Output formatting

## Separate matches into groups
zstyle ':completion:*:matches' group 'yes'

## Describe each match group.
zstyle ':completion:*:descriptions' format "%B---- %d%b"

### Messages/warnings format
#zstyle ':completion:*:messages' format '%B%U---- %d%u%b' 
#zstyle ':completion:*:warnings' format '%B%U---- no match for: %d%u%b'
## 
## Describe options in full
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'

### {{{ Array/association subscripts

# When completing inside array or association subscripts, the array
# elements are more useful than parameters so complete them first:
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters 

# Provide more processes in completion of programs like killall:
zstyle ':completion:*:processes-names' command 'ps c -u ${USER} -o command | uniq'

# # complete manual by their section
zstyle ':completion:*:manuals'separate-sections true
zstyle ':completion:*:manuals.*'  insert-sections   true
zstyle ':completion:*:man:*'  menu yes select

# Search path for sudo completion
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin \
   /usr/local/bin  \
   /usr/sbin   \
   /usr/bin\
   /sbin   \
   /bin\
   /usr/X11R6/bin
# {{{ Completion for processes

zstyle ':completion:*:*:*:*:processes' menu yes select
zstyle ':completion:*:*:*:*:processes' force-list always

zle -N incremental-complete-word
autoload zrecompile

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Pick item but stay in the menu
bindkey -M menuselect "+" accept-and-menu-complete
# ls <tab> +

# run rehash on completion so new installed program are found automatically:
    function _force_rehash () {
        (( CURRENT == 1 )) && rehash
        return 1
    }
    
    # PID completion for kill
zstyle ':completion:*:*:*:*:processes' command 'ps -u $LOGNAME -o pid,user,command -w'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*' insert-ids single

# SSH/SCP/RSYNC
zstyle ':completion:*:(scp|rsync):*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:(scp|rsync):*' group-order users files all-files hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:ssh:*' group-order users hosts-domain hosts-host users hosts-ipaddr
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-domain' ignored-patterns '<->.<->.<->.<->' '^[-[:alnum:]]##(.[-[:alnum:]]##)##' '*@*'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'
#setopt noxtrace
