# Usage: printc COLOR_CODE
printc() {
    local color="%F{$1}"
    echo -E ${(qqqq)${(%)color}}
}
