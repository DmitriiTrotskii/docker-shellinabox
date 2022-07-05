#!/bin/bash

set -e

COMMAND="/usr/bin/shellinaboxd --disable-peer-check --disable-ssl --user-css Normal:+/etc/shellinabox/options-enabled/00_White-On-Black.css;Colors:+/etc/shellinabox/options-enabled/01+Color-Terminal.css"

if [ "$SSH_SERVER" != "" ] && [ "$SSH_PORT" != "" ]; then
        COMMAND+=" -s /:SSH:${SSH_SERVER}:${SSH_PORT}"
fi

exec ${COMMAND}
