#!/usr/bin/env bash
# Author: Alexander Epstein https://github.com/alexanderepstein

# A script to easily transfer files to and from transfer.sh

transfer() {
    # check dependencies
    if ! command -v curl &>/dev/null; then
        echo "curl is not installed"
        return 1
    fi

    # upload a file
    if [ -f "$1" ]; then
        curl --upload-file "$1" "https://transfer.sh/$(basename "$1")"
        echo
        return
    fi

    # download a file
    if [ -n "$1" ] && [ -n "$2" ]; then
        curl "$1" > "$2"
        return
    fi

    echo "Usage: transfer <file> or transfer <url> <filename>"
}
