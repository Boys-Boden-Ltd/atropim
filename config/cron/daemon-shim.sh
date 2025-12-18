#!/bin/bash
if [[ "$@" == *"daemon"* ]]; then
    exec setsid /usr/local/bin/php "$@"
else
    exec /usr/local/bin/php "$@"
fi
