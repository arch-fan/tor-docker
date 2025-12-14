#!/bin/sh

set -e

config_file="/etc/tor/torrc"
config_dir=$(dirname "$config_file")
data_dir="${TOR_DataDirectory:-/var/lib/tor}"
run_prefix=""

if [ "$(id -u)" -eq 0 ]; then
  mkdir -p "$data_dir"
  chown -R tor:nogroup "$data_dir" "$config_dir"
  run_prefix="su-exec tor"
else
  # Non-root (K8s RunAsNonRoot, rootless Docker/Podman): best effort to ensure dirs exist.
  mkdir -p "$data_dir" 2>/dev/null || true
fi

if ! : >"$config_file"; then
  echo "ERROR: cannot write $config_file. Provide writable permissions (fsGroup, initContainer chown, or run as root)." >&2
  exit 1
fi

env | grep -e '^TOR_' | LC_COLLATE=C sort | while IFS= read -r line; do
  var_name=${line%%=*}
  var_value=${line#*=}
  tmp=${var_name#TOR_}

  case $tmp in
  [0-9]*_*) directive=${tmp#*_} ;;
  *) directive=$tmp ;;
  esac

  # Skip empty values to avoid emitting invalid torrc lines.
  [ -z "$var_value" ] && continue

  printf "%s %s\n" "$directive" "$var_value" >>"$config_file"
done

if [ $# -eq 0 ]; then
  set -- tor -f "$config_file"
fi

if [ -n "$run_prefix" ]; then
  exec $run_prefix "$@"
else
  exec "$@"
fi
