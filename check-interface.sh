#!/bin/bash

DURATION=$(</dev/stdin)
if (($DURATION <= 10000 )); then
    exit 60
else
    curl --silent --fail sphinx-relay.embassy:3300/app &>/dev/null
    exit_code=$?
    if test "$exit_code" != 0; then
        echo "Cannot connect to API" >&2
        exit 1
    fi
fi
