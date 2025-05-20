#!/usr/bin/env bash

config_file="/etc/tor/torrc"
: >"$config_file"

env | grep -e '^TOR_' | while read -r line; do
  var_name="${line%%=*}"
  var_value="${line#*=}"

  directive="${var_name#TOR_}"

  printf "%s %s\n" "$directive" "$var_value" >>"$config_file"
done

if [ $# -eq 0 ]; then
  set -- tor -f "$config_file"
fi
exec "$@"
