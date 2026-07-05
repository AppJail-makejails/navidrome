#!/bin/sh

. /lib.subr

set -e

create_user

chown -R noroot:noroot /data

if [ ! -f "${ND_CONFIGFILE}" ]; then
    echo -n > "${ND_CONFIGFILE}"
    chown noroot:noroot "${ND_CONFIGFILE}"
fi

exec su-exec noroot navidrome "$@"
