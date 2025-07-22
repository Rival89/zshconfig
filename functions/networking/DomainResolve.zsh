# Domain Resolution

function DomainResolve() {

  local _host="$1"
  local _timeout="15"

  _host_ip=$(curl -ks -m "$_timeout" "https://dns.google.com/resolve?name=${_host}&type=A" | \
  jq '.Answer[0].data' | tr -d "\"" 2>/dev/null)

  if [[ -z "$_host_ip" ]] || [[ "$_host_ip" == "null" ]] ; then
    echo -en "Unsuccessful domain name resolution.\n"
  else
    echo -en "$_host > $_host_ip\n"
  fi
}
