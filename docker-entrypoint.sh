#!/bin/bash
set -e

if [ "$1" = 'run' ]; then
    exec ./run.sh "$@"
fi

exec "$@"
