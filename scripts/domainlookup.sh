#!/bin/zsh

# Function to gather information about a domain
function domain_info {
    local domain=$1
    local output_file=$2
    local verbose=$3
    local info_sources=("${@:4}")
    local tmp_file=$(mktemp)

    if [ -z "$domain" ]; then
        echo "No domain provided"
        return 1
    fi

    echo "Gathering information for $domain"

    for info_source in "${info_sources[@]}"; do
        case $info_source in
            "whois")
                echo "WHOIS:" | tee -a $output_file
                gum spin --title "Running WHOIS..." -- sh -c "whois $domain > $tmp_file"
                cat $tmp_file | tee -a $output_file
                ;;
            "dns")
                echo "DNS:" | tee -a $output_file
                gum spin --title "Running DNS lookup..." -- sh -c "dig $domain any +noall +answer > $tmp_file"
                cat $tmp_file | tee -a $output_file
                ;;
            "ip")
                echo "IP:" | tee -a $output_file
                gum spin --title "Looking up IP..." -- sh -c "host $domain > $tmp_file"
                cat $tmp_file | tee -a $output_file
                ;;
            "shodan")
                echo "Shodan:" | tee -a $output_file
                gum spin --title "Running Shodan..." -- sh -c "shodan host $domain > $tmp_file"
                cat $tmp_file | tee -a $output_file
                ;;
            "nikto")
                echo "Nikto scan:" | tee -a $output_file
                gum spin --title "Running Nikto scan..." -- sh -c "nikto -h $domain > $tmp_file"
                cat $tmp_file | tee -a $output_file
                ;;
            *)
                echo "Unknown information source: $info_source"
                ;;
        esac
    done

    # Remove the temporary file
    rm $tmp_file
}

# Function to display help message
function display_help {
    echo "Usage: ./domain_info.sh [OPTIONS] DOMAIN"
    echo "Gather information about a domain."
    echo ""
    echo "Options:"
    echo "  --help        Display this help message"
    echo "  --verbose     Print more detailed information about what the script is doing"
    echo "  --output FILE Save the gathered information to FILE (default: domain_info.txt)"
    echo ""
    echo "Example:"
    echo "  ./domain_info.sh --verbose --output my_domain_info.txt example.com"
}

# Main function
function main {
    local domain
    local output_file="domain_info.txt"
    local verbose=false
    local info_sources=("whois" "dns" "ip" "shodan" "nikto")

    # Parse command-line options
    while (( $# )); do
        case $1 in
            --help)
                display_help
                return 0
                ;;
            --verbose)
                verbose=true
                shift
                ;;
            --output)
                output_file=$2
                shift 2
                ;;
            *)
                domain=$1
                shift
                ;;
        esac
    done

    # Check if domain was provided
    if [ -z "$domain" ]; then
        echo "No domain provided"
        return 1
    fi

    # Let the user choose which information to gather
    info_sources=($(gum choose --no-limit "${info_sources[@]}"))

    # Gather information about the domain
    domain_info $domain $output_file $verbose "${info_sources[@]}"
}

# Run the main function
main "$@"

