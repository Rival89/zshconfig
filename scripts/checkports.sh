#!/bin/bash

#Text Formating

bold=$(tput bold)
normal=$(tput sgr0)
red=$(tput setaf 1)
white=$(tput setaf 7)
yellow=$(tput setaf 3)

# Function to handle SIGINT and ask for confirmation before exiting.
handle_sigint() {
    if gum confirm "Are you sure you want to quit?"; then
        echo "Exiting..."
        exit 1
    else
        main
    fi
}

# Trap SIGINT.
trap handle_sigint SIGINT

# Function to get the running processes using ports.
get_processes() {
    sudo lsof -i -P -n | awk 'NR>1 {print $2 " " $1 " " $9}' | sort | uniq
}

# Function to kill a process.
kill_process() {
    local pid=$(echo $1 | awk '{print $1}')
    if gum confirm "Are you sure you want to kill process $pid?"; then
        sudo kill $pid && echo "${bold}${yellow}Process Terminated"
    else
        main
    fi
}

# Main function to list the processes and let the user choose one to kill.
main() {
    echo "$(gum style --foreground 212 'Select a process to kill: ')"

    local processes=$(get_processes)
    local choice=$(echo "$processes" | gum choose)

    if [ -n "$choice" ]; then
        kill_process "$choice"
    fi
}

# Run the main function.
main

## Function to handle SIGINT and ask for confirmation before exiting.
#handle_sigint() {
#    if gum confirm "Are you sure you want to quit?"; then
#        echo "Exiting..."
#        exit 1
#    else
#        main
#    fi
#}

## Trap SIGINT.
#trap handle_sigint SIGINT

## Function to get the running processes using ports.
#get_processes() {
#    lsof -i -P -n 2>/dev/null | awk '{print $1,$2,$9}' | uniq
#}

## Function to kill a process.
#kill_process() {
#    local pid=$(echo $1 | awk '{print $1}')
#    gum confirm "Are you sure you want to kill process $pid?" && kill $pid
#}

## Main function to list the processes and let the user choose one to kill.
#main() {
#    echo "$(gum style --foreground 212 'Select a process to kill: ')"

#    local processes=$(get_processes)
#    local choice=$(echo "$processes" | gum choose --height 25 --limit=1)

#    if [ -n "$choice" ]; then
#        kill_process "$choice"
#    fi
#}

## Run the main function.
#main



