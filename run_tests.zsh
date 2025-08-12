#!/usr/bin/env zsh

# Run the test suite using the bundled configuration
set -e
for test_file in tests/test_*.zsh; do
  echo "Running $test_file"
  zsh "$test_file"
done
