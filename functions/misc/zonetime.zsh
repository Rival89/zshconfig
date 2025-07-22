# Time Elsewhere
zonetime(){
  echo "$(timedatectl list-timezones)" | fzf | read TZ
  echo "$TZ : $(date +'%m/%d/%Y %I:%M %p')"
  unset TZ
}
