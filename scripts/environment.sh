#!/bin/zsh

# Define colors using tput
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

# Detect package manager
if command -v apt >/dev/null 2>&1; then
    PM_UPDATE="sudo apt update"
    PM_UPGRADE="sudo apt upgrade -y"
    PM_FULL_UPGRADE="sudo apt full-upgrade -y"
    PM_DIST_UPGRADE="sudo apt dist-upgrade -y"
    PM_INSTALL="sudo apt install -y"
    PM_REMOVE="sudo apt remove -y"
    PM_SEARCH="apt-cache search"
    PM_CLEAN="sudo apt autoremove -y"
elif command -v brew >/dev/null 2>&1; then
    PM_UPDATE="brew update"
    PM_UPGRADE="brew upgrade"
    PM_FULL_UPGRADE="brew upgrade"
    PM_DIST_UPGRADE="brew upgrade"
    PM_INSTALL="brew install"
    PM_REMOVE="brew uninstall"
    PM_SEARCH="brew search"
    PM_CLEAN="brew cleanup"
else
    echo "No supported package manager found." >&2
    exit 1
fi

# Define the menu options
options=("Update" "Full_Upgrade" "Dist_Upgrade" "Install" "Search" "Uninstall" "Help" "Exit")

# Display the menu using Gum
while true; do
    action=$(printf '%s\n' "${options[@]}" | gum choose --prompt "${YELLOW}Select an action${RESET}")

    case "$action" in
        "Update")
            # Update the system
            if gum confirm "${YELLOW}Are you sure you want to update the system?${RESET}"; then
                gum spin -- $PM_UPDATE
                gum spin -- $PM_UPGRADE
                gum spin -- $PM_CLEAN
                echo "${GREEN}System update complete.${RESET}"
            else
                echo "${RED}Operation cancelled.${RESET}"
            fi
            ;;
        "Full_Upgrade")
            # Perform a full upgrade
            if gum confirm "${YELLOW}Are you sure you want to perform a full upgrade?${RESET}"; then
                gum spin -- $PM_UPDATE
                gum spin -- $PM_FULL_UPGRADE
                gum spin -- $PM_CLEAN
                echo "${GREEN}Full upgrade complete.${RESET}"
            else
                echo "${RED}Operation cancelled.${RESET}"
            fi
            ;;
        "Dist_Upgrade")
            # Perform a distribution upgrade
            if gum confirm "${YELLOW}Are you sure you want to perform a distribution upgrade?${RESET}"; then
                gum spin -- $PM_UPDATE
                gum spin -- $PM_DIST_UPGRADE
                gum spin -- $PM_CLEAN
                echo "${GREEN}Distribution upgrade complete.${RESET}"
            else
                echo "${RED}Operation cancelled.${RESET}"
            fi
            ;;
        "Install")
            # Install a package
            echo "${YELLOW}Enter the name of the package you want to install:${RESET}"
            read package_name
            gum spin -- $PM_INSTALL $package_name
            echo "${GREEN}Package $package_name installed.${RESET}"
            ;;
        "Search")
            # Search for a package and install it
            echo "${YELLOW}Enter the name of the package you want to search for:${RESET}"
            read search_query
            package_name=$($PM_SEARCH $search_query | fzf | awk '{print $1}')
            gum spin -- $PM_INSTALL $package_name
            echo "${GREEN}Package $package_name installed.${RESET}"
            ;;
        "Uninstall")
            # Uninstall a package
            echo "${YELLOW}Enter the name of the package you want to uninstall:${RESET}"
            read package_name
            gum spin -- $PM_REMOVE $package_name
            echo "${GREEN}Package $package_name uninstalled.${RESET}"
            ;;
        "Help")
            # Display help information
            echo "${GREEN}This script provides an interactive menu for managing packages. Here's what each option does:${RESET}"
            echo "${YELLOW}Update:${RESET} Updates the package list, upgrades all upgradable packages, and removes unnecessary packages."
            echo "${YELLOW}Full_Upgrade:${RESET} Performs a full upgrade of the system."
            echo "${YELLOW}Dist_Upgrade:${RESET} Performs a distribution upgrade of the system."
            echo "${YELLOW}Install:${RESET} Prompts you to enter the name of a package to install."
            echo "${YELLOW}Search:${RESET} Prompts you to enter a search term, then presents a list of matching packages for you to choose from to install."
            echo "${YELLOW}Uninstall:${RESET} Prompts you to enter the name of a package to uninstall."
            echo "${YELLOW}Help:${RESET} Displays this help information."
            echo "${YELLOW}Exit:${RESET} Exits the script."
            ;;
        "Exit")
            # Exit the script
            echo "${GREEN}Exiting...${RESET}"
            break
            ;;
        *)
            echo "${RED}Invalid option.${RESET}"
            ;;
    esac
done

