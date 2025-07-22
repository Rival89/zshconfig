#!/usr/bin/env bash
# Author: Alexander Epstein https://github.com/alexanderepstein

# A script to easily access cheatsheets from cheat.sh

cheat() {
    if [ "$#" -eq 0 ]; then
        curl cheat.sh
    else
        curl cheat.sh/"$*"
    fi
}
