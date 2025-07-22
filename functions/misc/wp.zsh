# Query Wikipedia via console over DNS
# http://www.commandlinefu.com/commands/view/2829
wp() {
    dig +short txt ${1}.wp.dg.cx
}
