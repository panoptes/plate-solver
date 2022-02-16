#!/usr/bin/env bash

SOLVE_OPTS="${SOLVE_OPTS:-}"

# Comes from inotifywait. See watcher.sh
datetime=$1
dir=$2
filename=$3
event=$4

if [ ${filename##*.} == 'fits' ]; then
  /usr/bin/solve-field "${SOLVE_OPTS}" "${filename}"
fi
