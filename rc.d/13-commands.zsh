#!/bin/zsh

##
# Custom Commands, Functions, and Special Aliases

# Network Tings
alias sysinfo="$ZSH_CONFIG/scripts/sysinfo.sh"
alias diskspace="$ZSH_CONFIG/scripts/diskspace.sh"
alias services="$ZSH_CONFIG/scripts/services.sh"
alias transfer="$ZSH_CONFIG/scripts/transfer.sh"
alias short="$ZSH_CONFIG/scripts/short.sh"
alias movies="$ZSH_CONFIG/scripts/movies.sh"

function cna() {
    if [[ "$(uname)" == "Linux" ]]; then
        # Get a list of all network adapters
         adapters=$(ip link show | awk -F: '$0 !~ "lo|vir|docker|tap|br|eth|^[^0-9]"{print $2;getline}')


        # Check if there are any network adapters
        if [[ -z "$adapters" ]]; then
            echo "No network adapters found."
            return 1
        fi

        # Use gum to let the user choose an adapter
        chosen_adapter=$(echo "$adapters" | gum choose)

         # Removing leading whitespace from selected_adapter
         chosen_adapter=$(echo "$chosen_adapter" | sed -e 's/^[[:space:]]*//')

        # Check if the user chose an adapter
        if [[ -z "$chosen_adapter" ]]; then
            echo "No adapter chosen."
            return 1
        fi

        # Use gum to let the user choose a mode
        chosen_mode=$(echo -e "Monitor\nManaged" | gum choose)

        # Check if the user chose a mode
        if [[ -z "$chosen_mode" ]]; then
            echo "No mode chosen."
            return 1
        fi

        # Switch the chosen adapter to the chosen mode
        if [[ "$chosen_mode" == "Monitor" ]]; then
            sudo ip link set "$chosen_adapter" down
            sudo iw "$chosen_adapter" set monitor control
            sudo ip link set "$chosen_adapter" up
        else
            sudo ip link set "$chosen_adapter" down
            sudo iw "$chosen_adapter" set type managed
            sudo ip link set "$chosen_adapter" up
        fi
    else
        echo "This function is only available on Linux."
    fi
}

# File and Directory Tings


# History
# 2x control is completion from history!!!
# Define the custom widget
fzf-history-widget() {
  # Use fzf to select from the command history
  local selected_command=$(fc -l 1 | fzf --tac --query="$LBUFFER" | awk '{$1=""; print substr($0,2)}')
  if [[ -n "$selected_command" ]]; then
    # If a command was selected, add it to the command line
    BUFFER=$selected_command
    CURSOR=$#BUFFER
  fi
  zle redisplay
}


# Create the widget with zle
zle -N fzf-history-widget

# Unbind the current binding
bindkey -r '^X^X'

# Bind the widget to a new key sequence
bindkey '^X^X' fzf-history-widget


# Rename all files to lowercase
#for i in *; do mv "$i" "${i,,}"; done

alias theweather="curl wttr.in/Tucson"

zshaddhistory() {
    local line=${1%%$'\n'}
    local cmd=${line%% *}
    # Only those that satisfy all of the following conditions are added to the history
    [[ ${#line} -ge 5
       && ${cmd} != ll
       && ${cmd} != ls
       && ${cmd} != la
       && ${cmd} != cd
       && ${cmd} != man
       && ${cmd} != scp
       && ${cmd} != vim
       && ${cmd} != nvim
       && ${cmd} != less
       && ${cmd} != ping
       && ${cmd} != open
       && ${cmd} != file
       && ${cmd} != which
       && ${cmd} != whois
       && ${cmd} != drill
       && ${cmd} != uname
       && ${cmd} != md5sum
       && ${cmd} != pacman
       && ${cmd} != xdg-open
       && ${cmd} != traceroute
       && ${cmd} != speedtest-cli
    ]]
}
zshaddhistory

# These aliases enable us to paste example code into the terminal without the
# shell complaining about the pasted prompt symbol.
alias %= \$=


# zmv lets you batch rename (or copy or link) files by using pattern matching.
# https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#index-zmv
autoload -Uz zm
alias zmv='zmv -Mv'
alias zcp='zmv -Cv'
alias zln='zmv -Lv'

# Note that, unlike Bash, there's no need to inform Zsh's completion system
# of your aliases. It will figure them out automatically.


# Set $PAGER if it hasn't been set yet. We need it below.
# `:` is a builtin command that does nothing. We use it here to stop Zsh from
# evaluating the value of our $expansion as a command.
: ${PAGER:=less}

# Print most recently modified files in current directory. It takes no arguments
if [[ "$(uname)" == "Darwin" ]]; then
    alias mostrecent="find ${1} -type f -print0 | xargs -0 stat -f '%m %N' | sort -rn | head | cut -d' ' -f2-"
else
    alias mostrecent="find ${1} -type f | xargs stat --format '%Y :%y: %n' 2>/dev/null | sort -nr | cut -d: -f2,3,5 | head"
fi


findit() {
    # https://unix.stackexchange.com/questions/42841/how-to-skip-permission-denied-errors-when-running-find-in-linux
    if [ $# -ne 2 ]; then
        echo "findit: Search files and directories recursively. Unlike 'find', it does not pollute output with errors."
        echo "Usage:    findit <path> <some part of filename>"
        echo "Example:  findit / 'some_library'"
    else
        find "$1" -name "*$2*"  2>&1 | grep -v "Permission denied" | grep -v "No such file or directory" | grep -v "Invalid argument"
    fi
}

# Associate file .extensions with programs.
# This lets you open a file just by typing its name and pressing enter.
# Note that the dot is implicit. So, `gz` below stands for files ending in .gz
alias -s {css,gradle,html,js,json,md,patch,properties,txt,xml,yml}=$PAGER
alias -s gz='gzip -l'
alias -s {log,out}='tail -F'

#dirsize - finds directory sizes and lists them for the current directory
dirsize () {
  du -shx * .[a-zA-Z0-9_]* 2> /dev/null | \
  egrep '^ *[0-9.]*[MG]' | sort -n > /tmp/list
  egrep '^ *[0-9.]*M' /tmp/list
  egrep '^ *[0-9.]*G' /tmp/list
  rm -rf /tmp/list
}

share() {
    if [[ "$(uname)" == "Linux" ]]; then
      # `share ss`: Shares latest screenshots/image in the clipboard
      if [[ $1 = "ss" ]]; then
          img_path=/tmp/$(date +"%d_%m_%y-%H_%M_%m").png
          xclip -selection clipboard -t image/png -o >$img_path
          kdeconnect-cli -n sam --share $img_path

      # `share /some/path/file.ext`: Shares files
      else
          kdeconnect-cli -n sam --share $1
      fi
    else
        echo "This function is only available on Linux."
    fi
}

dmv() {
  __fname="$(ls -t ~/Downloads | head -n 1)"
  __fpath="$HOME/Downloads/"$__fname""
  mv "$__fpath" \.
}
dcp() {
    __fname="$(ls -t ~/Downloads | head -n 1)"
    __fpath="$HOME/Downloads/"$__fname""
    cp -a "$__fpath" \.
}

# Use `< file` to quickly view the contents of any file.
READNULLCMD=$PAGER  # Set the program to use for this.
