# kill pid that listens on given port
# e.g. kport 3000
kport() {
  local port=$1
  local pid=$(lsof -t -i :$port)
  if [[ -n $pid ]]; then
    echo "Killing process $pid listening on port $port"
    kill $pid
  else
    echo "No process found listening on port $port"
  fi
}
