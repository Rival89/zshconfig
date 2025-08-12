#!/bin/zsh

# Source all alias files
for alias_file in "$ZSH_CONFIG/aliases"/*.zsh(N); do
  source "$alias_file"
done
