ltk_system_version() {
  if [ -f "/etc/redhat-release" ]; then
    cat /etc/redhat-release
  elif [ -f "/etc/issue" ]; then
    cat /etc/issue
  else
    uname -a
  fi
}
