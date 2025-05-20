#!/bin/sh

config_file="/etc/tor/torrc"
: >"$config_file"

env | grep -e '^TOR_' | while IFS= read -r line; do
  var_name=${line%%=*}
  var_value=${line#*=}
  tmp=${var_name#TOR_}

  case $tmp in
  [0-9]*_*) directive=${tmp#*_} ;;
  *) directive=$tmp ;;
  esac

  printf "%s %s\n" "$directive" "$var_value" >>"$config_file"
done

if [ $# -eq 0 ]; then
  set -- tor -f "$config_file"
fi
exec "$@"
