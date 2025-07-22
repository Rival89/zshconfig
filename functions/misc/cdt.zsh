# Create temporary directory and cd to it
function cdt() {
    builtin cd "$(mktemp -d)"
    builtin pwd
}
