#!/bin/bash
set -e

# Foreground flag: -g (standard foreground) or -f (if USE_CONFIG_FILE_LOGGING is set)
FOREGROUND_FLAG="-g"
if [[ -n "${USE_CONFIG_FILE_LOGGING}" ]]; then
  FOREGROUND_FLAG="-f"
fi

# The user which will start the named process. Defaults to 'bind'.
BIND9_USER="${BIND9_USER:-bind}"

# Allow arguments to be passed to named
if [[ "${1:0:1}" == '-' ]]; then
    EXTRA_ARGS="${*}"
    set --
elif [[ "${1}" == "named" || "${1}" == "$(command -v named)" ]]; then
    EXTRA_ARGS="${*:2}"
    set --
fi

# Default behaviour is to launch named
if [[ -z "${1}" ]]; then
    echo "Starting ISC BIND 9 (${BIND9_USER})..."
    exec $(command -v named) -u "${BIND9_USER}" "${FOREGROUND_FLAG}" ${EXTRA_ARGS}
else
    exec "${@}"
fi
