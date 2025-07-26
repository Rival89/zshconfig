#!/usr/bin/env zsh

# Load the function to be tested
source "$(dirname "$0")/../functions/dirsearch"

fail() {
  echo "Test failed: $1" >&2
  exit 1
}

run_test() {
  "$@" > /dev/null || fail "$1 failed"
}

# Run the dirsearch function with a pattern
run_test dirsearch zsh

echo "All tests passed."
