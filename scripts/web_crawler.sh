#!/bin/bash

# Function to display help message
function display_help {
    echo "Usage: ./web_crawler.sh"
    echo "Crawl a target web domain to expose hidden files and directories."
    echo ""
    echo "Options:"
    echo "  --help        Display this help message"
    echo ""
    echo "Example:"
    echo "  ./web_crawler.sh"
}

# Main function
function main {
    local protocol_options=("http" "https")
    local wordlist_dir="/home/rival/wordlists"
    local extension_options=("sql" "zip" "xml" "backup" "passwd" "conf" "log" "yaml" "txt" "php" "pdf" "js" "html" "json" "docx" "additional?")
    local tool_options=("feroxbuster" "nmap" "whois" "dnsenum" "theHarvester" "dirb" "nikto")
    local save=""
    
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

    # Check if wordlist directory exists, if not create it
    if [ ! -d "$wordlist_dir" ]; then
        mkdir -p "$wordlist_dir"
    fi

    # Check if wordlist directory is empty, if so exit with error
    if [ -z "$(ls -A "$wordlist_dir")" ]; then
        echo "You must populate your wordlist directory"
        return 1
    fi

    # Ask user to input the target domain
    local target=$(gum input --prompt "Target domain: ")

    # Ask user to choose the protocol
    local protocol=$(echo "${protocol_options[@]}" | tr ' ' '\n' | gum choose)

    # Ask user to select a wordlist
    local wordlist=$(echo "$wordlist_dir" | gum file)

    # Ask user to select tools
    local tools=$(echo "${tool_options[@]}" | tr ' ' '\n' | gum choose --no-limit)

    # If feroxbuster is chosen, ask user to select extensions
    if echo "$tools" | grep -q "feroxbuster"; then
        local extensions=$(echo "${extension_options[@]}" | tr ' ' '\n' | gum choose --no-limit)

        # If "additional" is chosen, ask user to input extensions
        if echo "$extensions" | grep -q "additional"; then
            local manual_extensions=$(gum input --prompt "Enter extensions (comma-separated): ")
            extensions=$(echo "$extensions" | grep -v "additional")
            extensions=$(echo -e "$extensions\n$manual_extensions" | tr ',' '\n')
        fi

        # Convert extensions to comma-separated string
        local extensions_str=$(echo "$extensions" | tr '\n' ',')
    fi

    # Run feroxbuster
    if echo "$tools" | grep -q "feroxbuster"; then
        echo "Running feroxbuster on $protocol://$target"
        if [ -n "$extensions_str" ]; then
            gum spin --title "Running feroxbuster..." -- sh -c "feroxbuster -u "$protocol://$target" -w "$wordlist" -x "$extensions_str" -o "feroxbuster_$target.txt""
        else
            feroxbuster -u "$protocol://$target" -w "$wordlist" -o "feroxbuster_$target.txt"
        fi
    fi

    # Run nmap
    if echo "$tools" | grep -q "nmap"; then
        echo "Running nmap on $target"
        gum spin --title "Running nmap..." -- sh -c "nmap -v -A $target -oN "nmap_$target.txt""
    fi

    # Run whois
    if echo "$tools" | grep -q "whois"; then
        echo "Running whois on $target"
        gum spin --title "Running whois..." -- sh -c "whois $target > "whois_$target.txt""
    fi

    # Run dnsenum
    if echo "$tools" | grep -q "dnsenum"; then
        echo "Running dnsenum on $target"
        gum spin --title "Running dnsenum..." -- sh -c "dnsenum $target > "dnsenum_$target.txt""
    fi

    # Run theHarvester
    if echo "$tools" | grep -q "theHarvester"; then
        echo "Running theHarvester on $target"
        gum spin --title "Running theHarvester..." -- sh -c "theHarvester -d $target -b all > "theHarvester_$target.txt""
    fi

    # Run dirb
    if echo "$tools" | grep -q "dirb"; then
        echo "Running dirb on $protocol://$target"
        gum spin --title "Running dirb..." -- sh -c "dirb "$protocol://$target" "$wordlist" -o "dirb_$target.txt""
    fi

    # Run nikto
    if echo "$tools" | grep -q "nikto"; then
        echo "Running nikto on $protocol://$target"
        gum spin --title "Running nikto..." -- sh -c "nikto -h "$protocol://$target" -o "nikto_$target.txt""
    fi


    # Display the $target
    if [ -n "$save" ]; then
        cp dirb_$target.txt "${save}_dirb.txt"
        cp nmap_$target.txt "${save}_nmap.txt"
        cp nikto_$target.txt "${save}_nikto.txt"
        cp whois_$target.txt "${save}_whois.txt"
        cp dnsenum_$target.txt "${save}_dnsenum.txt"
        cp theHarvester_$target.txt "${save}_theHarvester.txt"
    fi
    if [ -z "$quiet" ]; then
        echo "Ferox $target:"
        gum pager < feroxbuster_$target.txt
        echo "Dirb $target:"
        gum pager < dirb_$target.txt
        echo "Nmap $target:"
        gum pager < nmap_$target.txt
        echo "Nikto $target:"
        gum pager < nikto_$target.txt
        echo "Whois $target:"
        gum pager < whois_$target.txt
        echo "dnsenum $target:"
        gum pager < dnsenum_$target.txt
        echo "theHarvester $target:"
        gum pager < theHarvester_$target.txt
    fi
}
# Run the main function
main "$@"

