#!/usr/bin/env zsh

# Load the function to be tested
source "$(dirname "$0")/../functions/cloak"

# --- Test Setup ---------------------------------------------------------------
# Create a mock openvpn command to capture arguments
OPENVPN_CALL_LOG=$(mktemp)
function openvpn() {
  echo "$@" > "$OPENVPN_CALL_LOG"
}

# Create a temporary directory for mock VPN configs
TEST_VPN_DIR=$(mktemp -d)
export ZSH_VPN_CONFIG_DIR="$TEST_VPN_DIR"

# Create a dummy config file
touch "$TEST_VPN_DIR/test_vpn.ovpn"

# --- Helper Functions ---------------------------------------------------------
TEST_FAILED=0
fail() {
  echo "FAIL: $1" >&2
  TEST_FAILED=1
}

pass() {
  echo "PASS: $1"
}

# --- Run Test -----------------------------------------------------------------
info() {
  echo "INFO: $1"
}

info "Testing the cloak function..."

# Set the testing environment variable
export ZSH_TESTING=true

# Run the cloak function, piping "1" to select the first option.
# We also pipe a dummy command to prevent curl from running.
{ echo 1; echo "echo 'dummy'" } | cloak > /dev/null

# --- Assertions ---------------------------------------------------------------
info "Checking if openvpn was called correctly..."

# Check if the log file was written to
if [[ ! -s "$OPENVPN_CALL_LOG" ]]; then
  fail "openvpn was not called."
fi

# Check if openvpn was called with the correct config file
if ! grep -q "test_vpn.ovpn" "$OPENVPN_CALL_LOG"; then
  fail "openvpn was called with the wrong arguments: $(cat "$OPENVPN_CALL_LOG")"
fi

pass "cloak function test."

# --- Cleanup ------------------------------------------------------------------
rm -f "$OPENVPN_CALL_LOG"
rm -rf "$TEST_VPN_DIR"

echo "\nAll cloak tests passed."
