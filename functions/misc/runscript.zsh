# Run a script from the zsh scripts folder ($ZDOTDIR/scripts)
function runscript() {
    if [[ -z "$1" ]]; then
        echo "Usage: runscript <script_name>"
        return 1
    fi
    local script_path="$ZDOTDIR/scripts/$1"
    if [[ ! -f "$script_path" ]]; then
        echo "Script not found: $script_path"
        return 1
    fi
    "$script_path"
}
