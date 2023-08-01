#!/bin/zsh

# History settings
#
# Always set these first, so history is preserved, no matter what happens.
#



# force zsh to show the complete history
alias history="history 0"


# Tell zsh where to store history.
HISTFILE=${XDG_DATA_HOME:=~/.local/share}/zsh/.history

# Just in case: If the parent directory doesn't exist, create it.
[[ -d $HISTFILE:h ]] || mkdir -p $HISTFILE:h

# Max number of history entries to keep in memory.
HISTSIZE=$(( SAVEHIST + SAVEHIST / 5 ))  # Zsh recommended value

## Max number of entries to keep in history file.
#SAVEHIST=$(( 100 * 1000 ))      # Use multiplication for readability.

## Max number of history entries to keep in memory.
#HISTSIZE=$(( 1.2 * SAVEHIST ))  # Zsh recommended value

# Use modern file-locking mechanisms, for better safety & performance.
setopt HIST_FCNTL_LOCK

# Keep only the most recent copy of each duplicate entry in history.
setopt HIST_IGNORE_ALL_DUPS

# Auto-sync history between concurrent sessions.
setopt SHARE_HISTORY

# delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt HIST_EXPIRE_DUPS_FIRST 

# ignore commands that start with space
setopt HIST_IGNORE_SPACE

# ignore duplicated commands history list
setopt HIST_IGNORE_DUPS

# show command with history expansion to user before running it
setopt HIST_VERIFY

# New history lines are added to the $HISTFILE incrementally
setopt INC_APPEND_HISTORY

# Directory Specifc History 
chpwd() {
    local ohistsize=$HISTSIZE
    fc -W ~-/.history.$UID
    HISTSIZE=0		# Discard previous dir's history
    HISTSIZE=$ohistsize	# Prepare for new dir's history
    fc -R ./.history.$UID
}


# HSTR configuration - add this to ~/.zshrc
alias hh=hstr                    # hh to be alias for hstr
setopt histignorespace           # skip cmds w/ leading space from history
export HSTR_CONFIG=hicolor       # get more colors
bindkey -s "\C-r" "\C-a hstr -- \C-j"     # bind hstr to Ctrl-r (for Vi mode check doc)

bindkey '\e[24~' end-of-line
# start typing + [Up-Arrow] - fuzzy find history forward
if [[ "${terminfo[kcuu1]}" != "" ]]; then
    autoload -U up-line-or-beginning-search
    zle -N up-line-or-beginning-search
    bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
fi
# start typing + [Down-Arrow] - fuzzy find history backward
if [[ "${terminfo[kcud1]}" != "" ]]; then
    autoload -U down-line-or-beginning-search
    zle -N down-line-or-beginning-search
    bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
fi

#bindkey '^[[24~' end-of-line
## start typing + [Up-Arrow] - fuzzy find history forward
#if [[ "^[[A" != "" ]]; then
#    autoload -U up-line-or-beginning-search
#    zle -N up-line-or-beginning-search
#    bindkey "^[[A" up-line-or-beginning-search
#fi
## start typing + [Down-Arrow] - fuzzy find history backward
#if [[ "^[[B" != "" ]]; then
#    autoload -U down-line-or-beginning-search
#    zle -N down-line-or-beginning-search
#    bindkey "^[[B" down-line-or-beginning-search
#fi

