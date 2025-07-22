ltk_pg() {
  # shellcheck disable=SC2009
  ps -ef | grep -i "$1"
}
