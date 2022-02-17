#!/usr/bin/env bash

SOLVE_OPTS="${SOLVE_OPTS:-}"

# Comes from inotifywait. See watcher.sh
datetime=$1
dir=$2
filename=$3
event=$4

echo "Event: $datetime $dir $filename $event"

if [ ${filename##*.} == 'fits' ]; then
  echo "Running solve-field: $SOLVE_OPTS ${dir}/${filename}"
  /usr/bin/solve-field $SOLVE_OPTS "${dir}/${filename}"
fi
