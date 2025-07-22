# show newest files
# http://www.commandlinefu.com/commands/view/9015/find-the-most-recently-changed-files-recursively
newest (){
  sudo find . -type f -printf '%TY-%Tm-%Td %TT %p\n' | \
  sudo grep -v cache | \
  sudo grep -v '.hg' | grep -v '.git' | \
  sort -r | \
  less
}
