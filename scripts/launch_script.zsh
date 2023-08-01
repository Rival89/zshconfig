#!/bin/bash

# Function to display help message
function display_help {
    echo "Usage: ./launch_script.sh"
    echo "List all .sh files in ~/.config/zsh/scripts/ and allow the user to select one to launch."
    echo ""
    echo "Options:"
    echo "  --help        Display this help message"
    echo ""
    echo "Example:"
    echo "  ./launch_script.sh"
}

# Main function
function main {
    local script_dir="$HOME/.config/zsh/scripts"
    local scripts
    local script_names

    # Parse command-line options
    while (( $# )); do
        case $1 in
            --help)
                display_help
                return 0
                ;;
            *)
                shift
                ;;
        esac
    done

    # Get list of .sh files
    scripts=$(find "$script_dir" -name "*.sh")

    # Get just the filenames
    script_names=$(echo "$scripts" | xargs -n 1 basename)

    # Ask user to select a script
    local script_name=$(echo "$script_names" | gum choose --height=10 --header="Select a Script" --cursor="• " --cursor.foreground="226" --item.foreground="226" --header.foreground="226")

    # Get the full path of the selected script
    local script=$(echo "$scripts" | grep "/$script_name$")

    # Launch the selected script with sudo
    if [ -n "$script" ]; then
        echo "Launching $script"
        sudo "$script"
    else
        echo "No script selected"
    fi
}

# Run the main function
main "$@"


