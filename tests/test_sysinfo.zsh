#!/usr/bin/env zsh
script_dir="$(dirname "$0")/.."
bash "$script_dir/scripts/sysinfo.sh" >/dev/null || true
