rgfzf () {
    # ripgrep
    if [ ! "$#" -gt 0 ]; then
        echo "Usage: rgfzf <query>"
        return 1
    fi
    rg --files-with-matches --no-messages "$1" | \
        fzf --prompt "$1 > " \
        --reverse --multi --preview "rg --ignore-case --pretty --context 10 '$1' {}"
}
