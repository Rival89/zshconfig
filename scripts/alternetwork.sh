#!/bin/bash


# Function to handle CTRL+C (SIGINT)
handle_sigint() {
    echo -e "\n$(gum style --foreground "#FF0000" "Operation cancelled.")"
    trap - SIGINT
    kill - SIGINT
}

# Set the trap
trap handle_sigint SIGINT



# Getting the list of network adapters
adapters=$(ip link show | awk -F: '$0 ~ "wl"{print $2;getline}')

# Displaying the list of network adapters using gum
selected_adapter=$(echo "$adapters" | gum choose)

# Removing leading whitespace from selected_adapter
selected_adapter=$(echo "$selected_adapter" | sed -e 's/^[[:space:]]*//')

# Choosing the mode for the adapter
mode=$(gum choose "Monitor" "Managed")

# Confirm before changing the mode of the adapter
if gum confirm "Are you sure you want to put $selected_adapter into $mode mode?"; then
    sudo ip link set "$selected_adapter" down
    if [ "$mode" = "Monitor" ]; then
        sudo iw "$selected_adapter" set monitor control
    else
        sudo iw "$selected_adapter" set type managed
    fi
    sudo ip link set "$selected_adapter" up
    echo "$(gum style --foreground "#00FF00" "$selected_adapter is now in $mode mode.")"
else
    echo "$(gum style --foreground "#FF0000" "Operation cancelled.")"
fi

