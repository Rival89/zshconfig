# ------------------------------------------------------------------------------
# This file contains initializations for third-party tools that are not
# managed by the zinit plugin manager but need to be hooked into the shell.
# ------------------------------------------------------------------------------

# --- Pyenv Initialization -----------------------------------------------------
# If pyenv is installed, initialize it to manage Python versions.
if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# --- Basher Initialization ----------------------------------------------------
# If basher is installed, initialize it to manage shell scripts.
if command -v basher >/dev/null 2>&1; then
  eval "$(basher init - zsh)"
fi

# --- The Fuck Initialization --------------------------------------------------
# If thefuck is installed, set up the 'fuck' alias for command correction.
if command -v thefuck >/dev/null 2>&1; then
  eval "$(thefuck --alias)"
fi
