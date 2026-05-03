#!/bin/sh

set -e

config_file="/run/tor/torrc"

: > "$config_file"

env | grep -e '^TOR_' | LC_COLLATE=C sort | while IFS= read -r line; do
  var_name=${line%%=*}
  var_value=${line#*=}
  tmp=${var_name#TOR_}

  case $tmp in
  [0-9]*_*) directive=${tmp#*_} ;;
  *) directive=$tmp ;;
  esac

  # Skip empty values to avoid emitting invalid torrc lines.
  [ -z "$directive" ] && continue
  [ -z "$var_value" ] && continue

  printf "%s %s\n" "$directive" "$var_value" >> "$config_file"
done

exec "$@"
