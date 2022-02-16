#!/usr/bin/env bash

OUTGOING_DIR="${OUTGOING_DIR:-/outgoing}"
SOLVE_OPTS="${SOLVE_OPTS:---guess-scale --no-verify --crpix-center --temp-axy --downsample 4 --no-plots --overwrite}"

# Comes from inotifywait. See watcher.sh
datetime=$1
dir=$2
filename=$3
event=$4

if [ ${filename##*.} == 'fits' ]; then
  /usr/bin/solve-field "${SOLVE_OPTS}" --dir "${OUTGOING_DIR}" "${filename}"
fi
