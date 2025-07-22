#!/usr/bin/env zsh

# Load zinit
source "/home/rival/.local/share/zinit/zinit.git/zinit.zsh"

# Load the zsh-test-runner framework
zinit ice as"program"
zinit light "molovo/zsh-test-runner"

# Load the function to be tested
source "$(dirname "$0")/../functions/misc/admin.zsh"

# Test case 1: Check if the admin function runs without errors
test_admin_function_runs_without_errors() {
    # Run the admin function and capture the output
    output=$(admin)
    # Assert that the output is not empty
    assert_not_empty "$output"
}

# Run the tests
ztr_run_tests
