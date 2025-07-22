ltk_netsg() {
  netstat -an | grep -i "$1"
}
