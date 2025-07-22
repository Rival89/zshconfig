# Usage: palette
palette() {
    for code in {0..255}; do
        print -Pn "%F{$code}${(l:3::0:)code}%f "
        if (( ($code + 1) % 10 == 0 )); then
            print ""
        fi
    done
    print ""
}
