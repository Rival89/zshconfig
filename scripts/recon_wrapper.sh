#!/bin/bash

# Simple reconnaissance orchestrator
# Checks for common tools and optionally runs them

set -e

TARGET="$1"
if [ -z "$TARGET" ]; then
  read -rp "Target host or domain: " TARGET
fi

check_tool() {
  command -v "$1" >/dev/null 2>&1
}

run_tool() {
  local tool="$1"; shift
  if ! check_tool "$tool"; then
    echo "$tool not found. Skipping." >&2
    return
  fi
  read -rp "Run $tool against $TARGET? [y/N] " ans
  if [[ "$ans" =~ ^[Yy]$ ]]; then
    "$tool" "$@" "$TARGET" | tee "${tool}_$TARGET.txt"
  fi
}

run_tool nmap -A
run_tool whois
run_tool dnsenum
run_tool theHarvester -d

echo "Recon complete."
