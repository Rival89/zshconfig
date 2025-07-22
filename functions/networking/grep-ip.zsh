grep-ip() {
  text="$(cat < /dev/stdin)"
  echo "$(echo $text | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')"
}
